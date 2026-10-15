<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Oman AI Case Guardian v2</title><link rel="stylesheet" href="assets/app.css"></head>
<body><aside>
<h2>⚖️ Case Guardian</h2>
<button data-view="dashboard">Dashboard</button><button data-view="cases">Cases</button>
<button data-view="evidence">Evidence Vault</button><button data-view="rules">Rule Detector</button>
<button data-view="research">Research Lab</button><button data-view="timeline">Timeline</button>
<button data-view="alerts">Live Alerts</button><button data-view="audit">Audit</button>
<div class="langs"><button data-lang="en">EN</button><button data-lang="bn">বাংলা</button><button data-lang="ar">العربية</button></div>
</aside><main><header><div><h1 data-i="title">Oman AI Case Guardian v2</h1><p data-i="sub">Evidence-first legal research & case intelligence</p></div>
<button id="voice">🎙️ Voice</button></header>
<section id="dashboard" class="view active"><div class="cards"><article>📁 <b id="docCount">0</b><small>Documents</small></article><article>🚨 <b id="alertCount">0</b><small>Alerts</small></article><article>⚠️ <b id="findingCount">0</b><small>Findings</small></article><article>⚖️ <b>6</b><small>Initial Rules</small></article></div>
<div class="panel"><h2>🧠 Citation-First AI</h2><textarea id="q" placeholder="Ask about your case..."></textarea><button class="primary" id="ask">Analyze</button><div id="answer"></div></div></section>
<section id="cases" class="view"><div class="panel"><h2>Case Workspace</h2><input id="caseNo" placeholder="Case No."><input id="caseTitle" placeholder="Case title"><textarea id="caseDesc" placeholder="Facts"></textarea><button class="primary" id="saveCase">Create Case</button><div id="casesList"></div></div></section>
<section id="evidence" class="view"><div class="panel"><h2>📁 Evidence Vault</h2><input id="caseId" type="number" placeholder="Case ID"><input id="files" type="file" multiple><button class="primary" id="upload">Upload & Hash</button><div id="evidenceList"></div></div></section>
<section id="rules" class="view"><div class="panel"><h2>🔎 Oman Rule Detector</h2><div id="rulesList"></div></div></section>
<section id="research" class="view"><div class="panel"><h2>🔬 Research Laboratory</h2><input id="rq" placeholder="e.g. wage protection, Article 53"><button class="primary" id="researchBtn">Search</button><div id="researchList"></div></div></section>
<section id="timeline" class="view"><div class="panel"><h2>🗓️ Case Timeline</h2><input id="timelineCase" type="number" placeholder="Case ID"><button class="primary" id="timelineBtn">Load Timeline</button><div id="timelineList"></div></div></section>
<section id="alerts" class="view"><div class="panel"><h2>🚨 Live Alerts</h2><div id="alertsList"></div></div></section>
<section id="audit" class="view"><div class="panel"><h2>🧾 Immutable-style Audit Trail</h2><p>Production should append-only audit events and protect logs from ordinary users.</p></div></section>
</main><script src="assets/app.js"></script></body></html>