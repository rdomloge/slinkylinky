// Dashboard background data fetcher — runs in a Web Worker
// Receives: { token, orgId, urls: string[] }
// Posts:    { type: 'SUCCESS', results: Array<object|null> }
//         | { type: 'ERROR' }

self.onmessage = async ({ data: { token, orgId, urls } }) => {
    async function safeJson(url) {
        try {
            const headers = { Authorization: `Bearer ${token}` };
            if (orgId) headers['X-Tenant-Override'] = orgId;
            const r = await fetch(url, { headers });
            return r.ok ? r.json() : null;
        } catch {
            return null;
        }
    }

    try {
        const results = await Promise.all(urls.map(safeJson));
        self.postMessage({ type: 'SUCCESS', results });
    } catch {
        self.postMessage({ type: 'ERROR' });
    }
};
