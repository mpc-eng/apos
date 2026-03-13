#!/usr/bin/env node
// APOS Pipeline Dashboard — zero-dependency local server
// Usage: node tools/sprint-board/server.js [port]

const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = parseInt(process.argv[2] || '3333', 10);
const ROOT = path.resolve(__dirname, '..', '..');

function jsonResponse(res, data, status = 200) {
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(data));
}

function readJSON(filePath) {
  try {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch {
    return null;
  }
}

function getAppData(slug) {
  const appDir = path.join(ROOT, 'apps', slug);
  const appState = readJSON(path.join(appDir, 'app-state.json'));
  const actionQueue = readJSON(path.join(appDir, 'action-queue.json'));
  const specs = [];
  const specsDir = path.join(appDir, 'specs');
  if (fs.existsSync(specsDir)) {
    for (const f of fs.readdirSync(specsDir)) {
      if (f.endsWith('.md')) specs.push(f.replace('.md', ''));
    }
  }
  return { appState, actionQueue, specs };
}

// ── Research & Triage Enrichment ──
// Loads research outputs and triage outputs, attaches summaries to ideas for dashboard display.

function loadResearchSummary(idea) {
  if (!idea.research_output_ref) return null;
  const filePath = path.resolve(ROOT, idea.research_output_ref);
  // Path traversal guard — only allow reads within the project root
  if (!filePath.startsWith(ROOT + path.sep)) return null;
  const research = readJSON(filePath);
  if (!research) return null;

  const competitors = (research.competitors || []).slice(0, 3).map(c => ({
    name: c.name,
    gap_type: c.gap_type || null,
    rating: c.app_store_rating || null,
    reviews: c.review_count || null,
  }));

  return {
    market_trend: research.market_sizing?.market_trend || null,
    trend_evidence: research.market_sizing?.trend_evidence || null,
    competitive_landscape: research.competitive_landscape || null,
    tam: research.market_sizing?.tam?.value || null,
    sam: research.market_sizing?.sam?.value || null,
    som: research.market_sizing?.som?.value || null,
    value_chain_deliverability: research.value_chain?.overall_deliverability || null,
    value_chain_bottleneck: research.value_chain?.bottleneck_summary || null,
    top_competitors: competitors,
    structural_advantages: research.regulatory_context?.structural_advantages || [],
    structural_risks: research.regulatory_context?.structural_risks || [],
    unknowns: research.unknowns || [],
    data_strategy_applicable: research.data_strategy?.module_applicable || false,
    data_strategy_architecture: research.data_strategy?.architecture_implication || null,
  };
}

function loadAllTriageData() {
  const state = readJSON(path.join(ROOT, 'state.json'));
  const triageMap = {}; // idea_id -> triage summary

  for (const app of (state?.app_registry || [])) {
    const pendingDir = path.join(ROOT, 'apps', app.slug, 'approvals', 'pending');
    if (!fs.existsSync(pendingDir)) continue;

    const files = fs.readdirSync(pendingDir).filter(f =>
      f.startsWith('triage') && f.endsWith('-output.json')
    );

    for (const file of files) {
      const triage = readJSON(path.join(pendingDir, file));
      if (!triage?.ideas) continue;

      for (const idea of triage.ideas) {
        const existing = triageMap[idea.idea_id];
        // Keep the most recent triage (by file timestamp or overwrite)
        if (!existing || (triage.timestamp > (existing._timestamp || ''))) {
          triageMap[idea.idea_id] = {
            _timestamp: triage.timestamp,
            concession_count: idea.concession_count ?? null,
            recommendation: idea.recommendation || null,
            ranked_position: idea.ranked_position ?? null,
            batch_size: triage.batch_size ?? null,
            loses_to: idea.loses_to || null,
            loses_to_reason: idea.loses_to_reason || null,
            rapid_prototype_eligible: idea.rapid_prototype_eligible || false,
            kill_brief: idea.kill_brief || null,
            kill_brief_responses: (idea.kill_brief_responses || []).map(r => ({
              prosecution_point: r.prosecution_point,
              response: r.response,
              evidence: r.evidence,
            })),
            checks: {
              value_hypothesis: { passed: idea.checks?.value_hypothesis?.passed ?? null },
              market_demand: { passed: idea.checks?.market_demand?.passed ?? null },
              competitor_gap: {
                passed: idea.checks?.competitor_gap?.passed ?? null,
                gap_durability: idea.checks?.competitor_gap?.gap_durability || null,
              },
              unit_economics: {
                passed: idea.checks?.unit_economics?.passed ?? null,
                ltv_cac_trajectory: idea.checks?.unit_economics?.ltv_cac_trajectory || null,
                pricing_model: idea.checks?.unit_economics?.pricing_model || null,
                estimated_mrr_12mo: idea.checks?.unit_economics?.estimated_mrr_12mo || null,
              },
            },
          };
        }
      }
    }
  }

  return triageMap;
}

function enrichIdeasWithResearchAndTriage(ideas) {
  const triageMap = loadAllTriageData();

  for (const idea of ideas) {
    // Attach research summary
    const rs = loadResearchSummary(idea);
    if (rs) idea.research_summary = rs;

    // Attach triage summary
    const ts = triageMap[idea.id];
    if (ts) {
      delete ts._timestamp;
      idea.triage_summary = ts;
    }
  }

  return ideas;
}

function handleAPI(req, res) {
  const url = new URL(req.url, `http://localhost:${PORT}`);

  // GET /api/state — global pipeline state
  if (req.method === 'GET' && url.pathname === '/api/state') {
    const state = readJSON(path.join(ROOT, 'state.json'));
    return jsonResponse(res, state);
  }

  // GET /api/ideas — all ideas
  if (req.method === 'GET' && url.pathname === '/api/ideas') {
    const ideas = readJSON(path.join(ROOT, 'ideas.json'));
    return jsonResponse(res, ideas || []);
  }

  // GET /api/pipeline — full pipeline overview (ideas + all apps)
  if (req.method === 'GET' && url.pathname === '/api/pipeline') {
    const state = readJSON(path.join(ROOT, 'state.json'));
    const ideas = readJSON(path.join(ROOT, 'ideas.json')) || [];
    enrichIdeasWithResearchAndTriage(ideas);
    const apps = {};
    for (const app of (state?.app_registry || [])) {
      apps[app.slug] = { registry: app, ...getAppData(app.slug) };
    }
    return jsonResponse(res, { state, ideas, apps });
  }

  // GET /api/app/:slug — full app data
  const appMatch = url.pathname.match(/^\/api\/app\/([a-z0-9-]+)$/);
  if (req.method === 'GET' && appMatch) {
    const data = getAppData(appMatch[1]);
    if (!data.appState) return jsonResponse(res, { error: 'App not found' }, 404);
    return jsonResponse(res, data);
  }

  // GET /api/app/:slug/lineage — compute lineage graph from existing data
  const lineageMatch = url.pathname.match(/^\/api\/app\/([a-z0-9-]+)\/lineage$/);
  if (req.method === 'GET' && lineageMatch) {
    const slug = lineageMatch[1];
    const lineage = computeLineage(slug);
    return jsonResponse(res, lineage);
  }

  // GET /api/app/:slug/metrics — aggregated build metrics
  const metricsMatch = url.pathname.match(/^\/api\/app\/([a-z0-9-]+)\/metrics$/);
  if (req.method === 'GET' && metricsMatch) {
    const metrics = computeMetrics(metricsMatch[1]);
    if (!metrics) return jsonResponse(res, { error: 'App not found' }, 404);
    return jsonResponse(res, metrics);
  }

  // GET /api/app/:slug/decisions — decision audit + session timeline
  const decisionsMatch = url.pathname.match(/^\/api\/app\/([a-z0-9-]+)\/decisions$/);
  if (req.method === 'GET' && decisionsMatch) {
    const decisions = computeDecisions(decisionsMatch[1]);
    if (!decisions) return jsonResponse(res, { error: 'App not found' }, 404);
    return jsonResponse(res, decisions);
  }

  // GET /api/metrics/cross-app — comparison metrics across all apps
  if (req.method === 'GET' && url.pathname === '/api/metrics/cross-app') {
    const state = readJSON(path.join(ROOT, 'state.json'));
    const apps = [];
    for (const app of (state?.app_registry || [])) {
      const m = computeMetrics(app.slug);
      if (m && m.build_progress.length > 0) {
        apps.push({
          slug: app.slug, name: app.name,
          specs_built: m.build_progress.length,
          sprints: m.sprints.length,
          compile_first_pass: m.first_pass.compile.rate,
          test_first_pass: m.first_pass.test.rate,
          review_first_pass: m.first_pass.review.rate,
          amendment_rate: m.amendments.rate,
          total_tests: m.test_coverage.total,
        });
      }
    }
    return jsonResponse(res, { apps, comparison_available: apps.length >= 2 });
  }

  // PUT /api/app/:slug/app-state — save updated app-state.json
  const saveMatch = url.pathname.match(/^\/api\/app\/([a-z0-9-]+)\/app-state$/);
  if (req.method === 'PUT' && saveMatch) {
    const MAX_BODY = 1024 * 1024; // 1 MB limit
    let body = '';
    req.on('data', chunk => {
      body += chunk;
      if (body.length > MAX_BODY) {
        req.destroy();
        return jsonResponse(res, { error: 'Request body too large (1 MB max)' }, 413);
      }
    });
    req.on('end', () => {
      try {
        const parsed = JSON.parse(body);
        const filePath = path.join(ROOT, 'apps', saveMatch[1], 'app-state.json');
        // Backup before writing
        const backup = filePath + '.bak';
        if (fs.existsSync(filePath)) fs.copyFileSync(filePath, backup);
        fs.writeFileSync(filePath, JSON.stringify(parsed, null, 2) + '\n');
        jsonResponse(res, { ok: true });
      } catch (e) {
        jsonResponse(res, { error: e.message }, 400);
      }
    });
    return;
  }

  return jsonResponse(res, { error: 'Not found' }, 404);
}

// ── Metrics Computation ──
// Aggregates build quality metrics from app-state.json, action-log.json, action-queue.json.
function computeMetrics(slug) {
  const state = readJSON(path.join(ROOT, 'state.json'));
  const appDir = path.join(ROOT, 'apps', slug);
  const appState = readJSON(path.join(appDir, 'app-state.json'));
  if (!appState) return null;

  const actionLog = readJSON(path.join(appDir, 'action-log.json'));
  const registry = (state?.app_registry || []).find(a => a.slug === slug);
  const wb = appState.pipeline?.wip_build;
  const buildProgress = wb?.build_progress || [];
  const sprints = wb?.sprints || [];

  // Build sprint→spec lookup
  const specToSprint = {};
  for (const s of sprints) {
    for (const id of (s.specs || [])) specToSprint[id] = s.sprint_number;
    for (const id of (s.amendments || [])) specToSprint[id] = s.sprint_number;
  }
  // Enrich build_progress with sprint info
  for (const bp of buildProgress) {
    if (!bp.sprint_number) bp.sprint_number = specToSprint[bp.spec_id] || null;
  }

  // First-pass rates
  function firstPass(field) {
    let passed = 0, total = 0;
    for (const bp of buildProgress) {
      total++;
      if ((bp[field] || 1) === 1) passed++;
    }
    return { passed, total, rate: total ? +(passed / total).toFixed(3) : 0 };
  }
  const fp = {
    compile: firstPass('compilation_attempts'),
    test: firstPass('test_execution_attempts'),
    review: firstPass('review_attempts'),
  };

  // First-pass by sprint
  const sprintNums = [...new Set(sprints.map(s => s.sprint_number))].sort((a, b) => a - b);
  const fpBySprint = sprintNums.map(sn => {
    const specs = buildProgress.filter(bp => bp.sprint_number === sn);
    const total = specs.length || 1;
    return {
      sprint: sn,
      compile: +(specs.filter(bp => (bp.compilation_attempts || 1) === 1).length / total).toFixed(3),
      test: +(specs.filter(bp => (bp.test_execution_attempts || 1) === 1).length / total).toFixed(3),
      review: +(specs.filter(bp => (bp.review_attempts || 1) === 1).length / total).toFixed(3),
      specs_count: specs.length,
    };
  });

  // Retry distribution
  function retryDist(field) {
    const vals = buildProgress.map(bp => bp[field] || 1);
    const mean = vals.length ? +(vals.reduce((a, b) => a + b, 0) / vals.length).toFixed(2) : 0;
    const max = vals.length ? Math.max(...vals) : 0;
    const maxSpec = buildProgress.find(bp => (bp[field] || 1) === max)?.spec_id || null;
    const bySprint = sprintNums.map(sn => {
      const sv = buildProgress.filter(bp => bp.sprint_number === sn).map(bp => bp[field] || 1);
      return { sprint: sn, mean: sv.length ? +(sv.reduce((a, b) => a + b, 0) / sv.length).toFixed(2) : 0 };
    });
    return { mean, max, max_spec: maxSpec, by_sprint: bySprint };
  }
  const retryDistribution = {
    compile: retryDist('compilation_attempts'),
    test: retryDist('test_execution_attempts'),
    review: retryDist('review_attempts'),
  };

  // Error categories from action-log
  const errorCategories = {};
  if (actionLog?.entries) {
    for (const e of actionLog.entries) {
      if ((e.event === 'retry' || e.event === 'failed') && e.error_category) {
        errorCategories[e.error_category] = (errorCategories[e.error_category] || 0) + 1;
      }
    }
  }

  // Amendments
  const amendments = buildProgress.filter(bp => bp.type === 'amendment' || bp.spec_id?.includes('-amend-'));
  const originals = buildProgress.filter(bp => !bp.type && !bp.spec_id?.includes('-amend-'));
  const perParent = {};
  for (const a of amendments) {
    const parent = a.parent_spec_id || a.spec_id.replace(/-amend-\d+$/, '');
    perParent[parent] = (perParent[parent] || 0) + 1;
  }

  // Test coverage
  const testsBySpec = buildProgress.map(bp => ({ spec_id: bp.spec_id, tests_total: bp.tests_total || 0, sprint: bp.sprint_number }));
  const allTests = testsBySpec.map(t => t.tests_total);
  const maxTests = buildProgress.reduce((best, bp) => (bp.tests_total || 0) > (best.tests_total || 0) ? bp : best, buildProgress[0]);
  const testBySprint = sprintNums.map(sn => {
    const st = testsBySpec.filter(t => t.sprint === sn);
    const delta = st.reduce((sum, t) => sum + t.tests_total, 0);
    return { sprint: sn, delta, specs: st.length };
  });
  // Compute cumulative
  let cumulative = 0;
  for (const t of testBySprint) { cumulative += t.delta; t.cumulative = cumulative; }

  // Sprint velocity
  const sprintVelocity = sprintNums.map(sn => {
    const sprint = sprints.find(s => s.sprint_number === sn);
    const specsCount = (sprint?.specs || []).length;
    const amendsCount = (sprint?.amendments || []).length;
    return { sprint: sn, specs: specsCount, amendments: amendsCount, total: specsCount + amendsCount };
  });

  // Context efficiency from action-log
  const bundles = [];
  const tokens = [];
  if (actionLog?.entries) {
    for (const e of actionLog.entries) {
      if (e.context_bundle_kb != null) bundles.push({ action_id: e.action_id, kb: e.context_bundle_kb, agent: e.agent });
      if (e.input_tokens != null || e.output_tokens != null) {
        tokens.push({ action_id: e.action_id, input: e.input_tokens, output: e.output_tokens, agent: e.agent });
      }
    }
  }

  return {
    app: { name: registry?.name || slug, slug },
    sprints: sprints.map(s => ({
      sprint_number: s.sprint_number,
      specs: s.specs || [],
      amendments: s.amendments || [],
      deploy_date: s.deploy_date,
      retro_skipped: s.owner_override_skip_retro || false,
    })),
    build_progress: buildProgress,
    first_pass: fp,
    first_pass_by_sprint: fpBySprint,
    retry_distribution: retryDistribution,
    error_categories: errorCategories,
    amendments: {
      total: amendments.length,
      originals: originals.length,
      rate: originals.length ? +(amendments.length / originals.length).toFixed(3) : 0,
      per_parent: Object.entries(perParent).map(([parent, count]) => ({ parent, count })),
    },
    test_coverage: {
      total: maxTests?.tests_total || 0,
      mean: allTests.length ? +(allTests.reduce((a, b) => a + b, 0) / allTests.length).toFixed(1) : 0,
      min: allTests.length ? Math.min(...allTests) : 0,
      max: allTests.length ? Math.max(...allTests) : 0,
      by_sprint: testBySprint,
    },
    sprint_velocity: sprintVelocity,
    context_efficiency: { available: bundles.length > 0 || tokens.length > 0, bundles, tokens },
  };
}

// ── Decisions Computation ──
// Aggregates owner decisions, gate results, and session timeline.
function computeDecisions(slug) {
  const state = readJSON(path.join(ROOT, 'state.json'));
  const appDir = path.join(ROOT, 'apps', slug);
  const appState = readJSON(path.join(appDir, 'app-state.json'));
  if (!appState) return null;

  const actionLog = readJSON(path.join(appDir, 'action-log.json'));
  const actionQueue = readJSON(path.join(appDir, 'action-queue.json'));
  const registry = (state?.app_registry || []).find(a => a.slug === slug);
  const wb = appState.pipeline?.wip_build;
  const buildProgress = wb?.build_progress || [];
  const sprints = wb?.sprints || [];

  // Sprint→spec lookup
  const specToSprint = {};
  for (const s of sprints) {
    for (const id of (s.specs || [])) specToSprint[id] = s.sprint_number;
    for (const id of (s.amendments || [])) specToSprint[id] = s.sprint_number;
  }

  // Decision events from action-log
  const decisionEvents = ['owner_approved', 'owner_rejected', 'override_applied', 'resubmitted'];
  const decisions = [];
  if (actionLog?.entries) {
    for (const e of actionLog.entries) {
      if (decisionEvents.includes(e.event)) {
        decisions.push({ timestamp: e.timestamp, action_id: e.action_id, event: e.event, agent: e.agent, detail: e.detail });
      }
    }
  }

  // Overrides from app-state + action-queue
  const queueOverrides = [];
  if (actionQueue?.queue) {
    for (const act of actionQueue.queue) {
      if (act.override) {
        queueOverrides.push({ action_id: act.id, action: act.action, agent: act.agent, override: act.override });
      }
    }
  }

  // Gate results from build_progress
  const gateResults = buildProgress.map(bp => ({
    spec_id: bp.spec_id,
    sprint: bp.sprint_number || specToSprint[bp.spec_id] || null,
    type: bp.type || (bp.spec_id?.includes('-amend-') ? 'amendment' : 'original'),
    review_passed: bp.review_passed,
    review_attempts: bp.review_attempts || 1,
    review_notes: bp.review_notes || null,
    compilation_attempts: bp.compilation_attempts || 1,
    test_execution_attempts: bp.test_execution_attempts || 1,
  }));

  // Session timeline — group action-log entries by >2hr gaps
  const timeline = [];
  if (actionLog?.entries?.length) {
    const sorted = [...actionLog.entries].sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
    let session = { session_id: 1, start: sorted[0].timestamp, end: sorted[0].timestamp, events: [sorted[0]] };
    for (let i = 1; i < sorted.length; i++) {
      const gap = new Date(sorted[i].timestamp) - new Date(sorted[i - 1].timestamp);
      if (gap > 2 * 60 * 60 * 1000) {
        session.end = sorted[i - 1].timestamp;
        session.duration_minutes = Math.round((new Date(session.end) - new Date(session.start)) / 60000);
        timeline.push(session);
        session = { session_id: timeline.length + 1, start: sorted[i].timestamp, end: sorted[i].timestamp, events: [] };
      }
      session.events.push(sorted[i]);
    }
    session.end = sorted[sorted.length - 1].timestamp;
    session.duration_minutes = Math.round((new Date(session.end) - new Date(session.start)) / 60000);
    timeline.push(session);
  }

  // Agent statuses from action-queue — priority: in_progress > failed > pending > completed > blocked > skipped
  const statusPriority = { in_progress: 6, failed: 5, pending: 4, blocked: 3, completed: 2, skipped: 1 };
  const agentStatuses = {};
  if (actionQueue?.queue) {
    for (const act of actionQueue.queue) {
      if (act.agent) {
        const cur = statusPriority[agentStatuses[act.agent]] || 0;
        const next = statusPriority[act.status] || 0;
        if (next > cur) agentStatuses[act.agent] = act.status;
      }
    }
  }

  return {
    app: { name: registry?.name || slug, slug },
    decisions,
    overrides: {
      manual_override: appState.manual_override || null,
      tier_1_5_override: appState.tier_1_5_override || null,
      queue_overrides: queueOverrides,
    },
    gate_results: gateResults,
    timeline,
    agent_statuses: agentStatuses,
  };
}

// ── Lineage Graph Computation ──
// Derives a full dependency/artifact graph from existing pipeline data.
// No new data files needed — everything comes from ideas.json, app-state.json, action-queue.json.
function computeLineage(slug) {
  const state = readJSON(path.join(ROOT, 'state.json'));
  const ideas = readJSON(path.join(ROOT, 'ideas.json')) || [];
  const appDir = path.join(ROOT, 'apps', slug);
  const appState = readJSON(path.join(appDir, 'app-state.json'));
  const actionQueue = readJSON(path.join(appDir, 'action-queue.json'));

  const nodes = [];
  const links = [];
  const nodeMap = new Set();

  function addNode(n) {
    if (nodeMap.has(n.id)) return;
    nodeMap.add(n.id);
    nodes.push(n);
  }
  function addLink(source, target, type) {
    if (!nodeMap.has(source) || !nodeMap.has(target)) return;
    links.push({ source, target, type: type || 'blocks' });
  }

  // 1. Find the idea that spawned this app
  const registry = (state?.app_registry || []).find(a => a.slug === slug);
  const appName = (registry?.name || '').toLowerCase().replace(/[^a-z0-9]/g, '');
  const matchingIdea = ideas.find(i => {
    if (i.id?.includes(slug)) return true;
    const ideaName = (i.title || '').toLowerCase().replace(/[^a-z0-9]/g, '');
    // Match if idea title contains the app name or vice versa
    if (ideaName.includes(appName) || appName.includes(ideaName)) return true;
    // Match slug within title (e.g., "boxingai" in "BoxingAI — AI Boxing Technique Coach")
    if (ideaName.includes(slug)) return true;
    return false;
  });

  if (matchingIdea) {
    addNode({
      id: `idea_${matchingIdea.id}`,
      type: 'idea',
      label: matchingIdea.title,
      status: matchingIdea.status === 'killed' ? 'failed' : 'completed',
      score: matchingIdea.score,
      sprint: null,
      phase: null,
    });

    // If researched or cloned, add that node
    if (matchingIdea.status === 'researched' || matchingIdea.research_output_ref) {
      addNode({ id: `research_${matchingIdea.id}`, type: 'triage', label: 'Deep Research', status: 'completed', sprint: null, phase: null });
      addLink(`idea_${matchingIdea.id}`, `research_${matchingIdea.id}`, 'informs');
    }
    if (matchingIdea.status === 'cloned' || matchingIdea.clone_output_ref) {
      addNode({ id: `clone_${matchingIdea.id}`, type: 'triage', label: 'Clone Analysis', status: 'completed', sprint: null, phase: null });
      addLink(`idea_${matchingIdea.id}`, `clone_${matchingIdea.id}`, 'informs');
    }
  }

  // 2. Manual override node
  if (appState?.manual_override) {
    const mo = appState.manual_override;
    addNode({
      id: 'override_promote',
      type: 'override',
      label: 'Manual Override',
      status: 'completed',
      override_reason: mo.reason,
      completed_at: mo.date,
      sprint: null, phase: null,
    });
    if (matchingIdea) addLink(`idea_${matchingIdea.id}`, 'override_promote', 'informs');
  }

  // 3. Action queue → nodes and edges
  if (actionQueue?.queue) {
    for (const act of actionQueue.queue) {
      const nodeType = actionToNodeType(act.action);
      const label = actionToLabel(act);

      addNode({
        id: act.id,
        type: nodeType,
        label,
        status: act.status,
        agent: act.agent,
        sprint: act.sprint_number,
        phase: act.phase,
        output_path: act.output_path,
        retry_count: act.retry_count,
        completed_at: act.completed_at,
        spec_id: act.spec_id,
      });

      // depends_on → blocks edges
      for (const dep of (act.depends_on || [])) {
        addLink(dep, act.id, 'blocks');
      }

      // typed dependencies (3.4.0)
      if (act.dependencies) {
        for (const dep of act.dependencies) {
          addLink(dep.action_id, act.id, dep.type === 'supersedes' ? 'amends' : dep.type === 'relates_to' ? 'informs' : 'blocks');
        }
      }
    }

    // Link idea → first foundation action
    const firstAction = actionQueue.queue[0];
    if (firstAction && matchingIdea) {
      addLink(`idea_${matchingIdea.id}`, firstAction.id, 'informs');
    }
    if (firstAction && appState?.manual_override) {
      addLink('override_promote', firstAction.id, 'informs');
    }
  }

  // 4. Build progress → enrich with test/review data
  const wb = appState?.pipeline?.wip_build;
  if (wb?.build_progress) {
    for (const bp of wb.build_progress) {
      // Find spec node in queue
      const specQueueNode = nodes.find(n => n.spec_id === bp.spec_id && n.type === 'spec');
      if (specQueueNode) {
        specQueueNode.tests_total = bp.tests_total;
        specQueueNode.tests_passed = bp.tests_passed;
      }

      // Enrich review nodes
      const reviewNode = nodes.find(n => n.spec_id === bp.spec_id && n.type === 'review');
      if (reviewNode && bp.review_notes) {
        reviewNode.review_notes = bp.review_notes;
      }

      // Amendment parent links
      if (bp.type === 'amendment' && bp.parent_spec_id) {
        const parentSpecNode = nodes.find(n => n.spec_id === bp.parent_spec_id && n.type === 'spec');
        const amendSpecNode = nodes.find(n => n.spec_id === bp.spec_id && n.type === 'spec');
        if (parentSpecNode && amendSpecNode) {
          addLink(parentSpecNode.id, amendSpecNode.id, 'amends');
        }
      }
    }
  }

  // 5. Sprint milestones
  if (wb?.sprints) {
    for (const sprint of wb.sprints) {
      const deployId = `milestone_deploy_s${sprint.sprint_number}`;
      if (sprint.deploy_date) {
        addNode({
          id: deployId,
          type: 'milestone',
          label: `Sprint ${sprint.sprint_number} Deploy`,
          status: 'completed',
          sprint: sprint.sprint_number,
          phase: 2,
          completed_at: sprint.deploy_date,
        });

        // Link all reviews in this sprint → deploy
        const sprintReviews = nodes.filter(n =>
          n.type === 'review' && n.sprint === sprint.sprint_number && n.status === 'completed'
        );
        for (const rev of sprintReviews) {
          addLink(rev.id, deployId, 'blocks');
        }

        // Also check for sprint_deploy action
        const deployAction = actionQueue?.queue?.find(a =>
          a.action === 'sprint_deploy' && a.sprint_number === sprint.sprint_number
        );
        if (deployAction) {
          addLink(deployAction.id, deployId, 'blocks');
        }
      }

      // Retro
      if (sprint.retro_date || sprint.retro_output) {
        const retroId = `milestone_retro_s${sprint.sprint_number}`;
        addNode({
          id: retroId,
          type: 'retro',
          label: `Sprint ${sprint.sprint_number} Retro`,
          status: sprint.owner_override_skip_retro ? 'completed' : (sprint.retro_date ? 'completed' : 'pending'),
          sprint: sprint.sprint_number,
          phase: 2,
          completed_at: sprint.retro_date,
        });
        if (sprint.deploy_date) addLink(deployId, retroId, 'blocks');

        // Retro → next sprint planning
        const nextSprintPlanning = actionQueue?.queue?.find(a =>
          a.action === 'sprint_planning' && a.sprint_number === sprint.sprint_number + 1
        );
        if (nextSprintPlanning) {
          addLink(retroId, nextSprintPlanning.id, 'informs');
        }
      }
    }
  }

  // 6. Tier 1.5 override
  if (appState?.tier_1_5_override) {
    const t15Id = 'override_tier15';
    if (!nodeMap.has(t15Id)) {
      addNode({
        id: t15Id,
        type: 'override',
        label: 'Tier 1.5 Bypass',
        status: 'completed',
        override_reason: appState.tier_1_5_override.reason,
        completed_at: appState.tier_1_5_override.date,
        sprint: null, phase: 1,
      });
      // Link to tier checkpoint action
      const tierAction = actionQueue?.queue?.find(a => a.action === 'tier_1_5_checkpoint');
      if (tierAction) addLink(t15Id, tierAction.id, 'informs');
    }
  }

  return { nodes, links, app: registry?.name || slug, slug };
}

function actionToNodeType(action) {
  const map = {
    'generate_prd': 'foundation', 'generate_architecture': 'foundation',
    'generate_design': 'foundation', 'requirements_research': 'foundation',
    'requirements_review': 'review', 'project_config': 'foundation',
    'design_system_setup': 'foundation', 'tier_1_5_checkpoint': 'milestone',
    'sprint_planning': 'milestone', 'generate_spec': 'spec',
    'generate_code': 'code', 'compile_check': 'compile',
    'generate_tests': 'test', 'test_execution': 'compile',
    'review': 'review', 'review_lint': 'review',
    'sprint_deploy': 'milestone', 'sprint_retro': 'retro',
    'ux_checkpoint': 'review', 'pmf_gate': 'milestone',
    'generate_amendment_spec': 'amendment',
  };
  return map[action] || 'spec';
}

function actionToLabel(act) {
  const labels = {
    'generate_prd': 'PRD',
    'generate_architecture': 'Architecture',
    'generate_design': 'Design Brief',
    'requirements_research': 'Requirements',
    'requirements_review': 'Requirements Review',
    'project_config': 'Project Config',
    'design_system_setup': 'Design System',
    'tier_1_5_checkpoint': 'Tier 1.5 Check',
    'sprint_planning': `Sprint ${act.sprint_number || '?'} Plan`,
    'sprint_deploy': `Sprint ${act.sprint_number || '?'} Deploy`,
    'sprint_retro': `Sprint ${act.sprint_number || '?'} Retro`,
    'ux_checkpoint': 'UX Checkpoint',
    'pmf_gate': 'PMF Gate',
  };
  if (labels[act.action]) return labels[act.action];
  if (act.spec_id) {
    const specLabel = act.spec_id.replace(/^\d{3}-/, '').replace(/-/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
    const actionLabel = { 'generate_spec': 'Spec', 'generate_code': 'Code', 'compile_check': 'Compile', 'generate_tests': 'Tests', 'test_execution': 'Test Run', 'review': 'Review', 'review_lint': 'Lint' };
    return `${actionLabel[act.action] || act.action}: ${specLabel}`;
  }
  return act.action.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
}

const server = http.createServer((req, res) => {
  // CORS for local dev
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, PUT, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }

  // API routes
  if (req.url.startsWith('/api/')) return handleAPI(req, res);

  // Static files — route /sprint/:slug, /lineage/:slug, /metrics/:slug, /decisions/:slug
  const sprintRoute = req.url.match(/^\/sprint\/[a-z0-9-]+$/);
  const lineageRoute = req.url.match(/^\/lineage\/[a-z0-9-]+$/);
  const metricsRoute = req.url.match(/^\/metrics\/[a-z0-9-]+$/);
  const decisionsRoute = req.url.match(/^\/decisions\/[a-z0-9-]+$/);
  let filePath = path.join(__dirname,
    req.url === '/' ? 'index.html' :
    sprintRoute ? 'sprint.html' :
    lineageRoute ? 'lineage.html' :
    metricsRoute ? 'metrics.html' :
    decisionsRoute ? 'decisions.html' :
    req.url);
  const ext = path.extname(filePath);
  const mimeTypes = { '.html': 'text/html', '.js': 'application/javascript', '.css': 'text/css' };

  fs.readFile(filePath, (err, content) => {
    if (err) { res.writeHead(404); res.end('Not found'); return; }
    res.writeHead(200, { 'Content-Type': mimeTypes[ext] || 'text/plain' });
    res.end(content);
  });
});

server.listen(PORT, () => {
  console.log(`\n  APOS Pipeline Dashboard`);
  console.log(`  http://localhost:${PORT}\n`);
});
