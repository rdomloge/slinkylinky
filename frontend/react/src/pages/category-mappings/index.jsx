import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/auth/AuthProvider';
import Layout from '@/components/layout/Layout';
import Loading from '@/components/Loading';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { useToast } from '@/components/atoms/Toasts';

const STATUS_CONFIG = {
    PENDING: { label: 'Pending',  bg: 'bg-amber-100',   text: 'text-amber-700',   dot: '#f59e0b' },
    MAPPED:  { label: 'Mapped',   bg: 'bg-emerald-100', text: 'text-emerald-700', dot: '#10b981' },
    IGNORED: { label: 'Ignored',  bg: 'bg-slate-100',   text: 'text-slate-500',   dot: '#94a3b8' },
};

function StatusBadge({ status }) {
    const cfg = STATUS_CONFIG[status] ?? STATUS_CONFIG.PENDING;
    return (
        <span className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-[11px] font-semibold ${cfg.bg} ${cfg.text}`}>
            <span className="w-1.5 h-1.5 rounded-full shrink-0" style={{ background: cfg.dot }} />
            {cfg.label}
        </span>
    );
}

export default function CategoryMappingsIndex() {
    const { user } = useAuth();
    const navigate = useNavigate();
    const isGlobalAdmin = user?.roles?.includes('global_admin');
    const toast = useToast();

    const [mappings, setMappings] = useState(null);
    const [error, setError]       = useState(null);
    const [deletingId, setDeletingId] = useState(null);

    useEffect(() => {
        if (user && !isGlobalAdmin) navigate('/');
    }, [user, isGlobalAdmin, navigate]);

    useEffect(() => {
        if (!isGlobalAdmin) return;
        fetchMappings();
    }, [isGlobalAdmin]);

    async function fetchMappings() {
        try {
            const r = await fetchWithAuth('/.rest/engagements/category-mappings');
            if (!r.ok) throw new Error(r.status);
            setMappings(await r.json());
        } catch {
            setError('Could not load category mappings');
        }
    }

    async function deleteMapping(mapping) {
        setDeletingId(mapping.id);
        try {
            const r = await fetchWithAuth(`/.rest/engagements/category-mappings/${mapping.id}`, { method: 'DELETE' });
            if (!r.ok) throw new Error(r.status);
            setMappings(prev => prev.filter(m => m.id !== mapping.id));
            toast(`Mapping for "${mapping.collaboratorCategory}" deleted`, 'success');
        } catch {
            toast('Failed to delete mapping', 'error');
        } finally {
            setDeletingId(null);
        }
    }

    const pendingCount = mappings?.filter(m => m.status === 'PENDING').length ?? 0;

    return (
        <Layout
            pagetitle="Category Mappings"
            headerTitle={
                <span className="flex items-center gap-2">
                    Category Mappings
                    {mappings && (
                        <span className="text-sm font-normal text-slate-400">({mappings.length})</span>
                    )}
                    {pendingCount > 0 && (
                        <span className="inline-flex items-center gap-1.5 text-xs font-medium text-amber-700 bg-amber-50 border border-amber-200 rounded-full px-2.5 py-0.5">
                            <span className="w-1.5 h-1.5 rounded-full bg-amber-400" />
                            {pendingCount} pending
                        </span>
                    )}
                </span>
            }
        >
            {mappings ? (
                mappings.length === 0 ? (
                    <div className="flex flex-col items-center justify-center py-24 text-center gap-3">
                        <div className="w-14 h-14 rounded-2xl bg-slate-50 border border-slate-100 flex items-center justify-center">
                            <svg className="w-7 h-7 text-slate-400" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                                <path strokeLinecap="round" strokeLinejoin="round" d="M9.568 3H5.25A2.25 2.25 0 0 0 3 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 0 0 5.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 0 0 9.568 3Z" />
                                <path strokeLinecap="round" strokeLinejoin="round" d="M6 6h.008v.008H6V6Z" />
                            </svg>
                        </div>
                        <p className="text-slate-600 font-medium text-sm">No category mappings yet</p>
                        <p className="text-slate-400 text-xs max-w-xs">Mappings are created automatically when the Collaborator scraper runs and encounters new categories.</p>
                    </div>
                ) : (
                    <div className="px-6 pb-6">
                        <p className="text-slate-400 text-xs mb-4 px-0.5">
                            These mappings translate Collaborator.pro categories to SlinkyLinky categories.
                            Leads with <strong className="text-amber-600">Pending</strong> categories cannot be actioned until they are mapped or ignored.
                            Deleting a mapping resets it to Pending on the next scrape.
                        </p>
                        <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                            <table className="w-full text-sm border-collapse">
                                <thead>
                                    <tr className="border-b border-slate-100 text-left">
                                        <th className="px-4 py-3 text-[11px] font-semibold text-slate-500 uppercase tracking-wide">Collaborator Category</th>
                                        <th className="px-4 py-3 text-[11px] font-semibold text-slate-500 uppercase tracking-wide">SlinkyLinky Category</th>
                                        <th className="px-4 py-3 text-[11px] font-semibold text-slate-500 uppercase tracking-wide">Status</th>
                                        <th className="px-4 py-3 text-[11px] font-semibold text-slate-500 uppercase tracking-wide">Actions</th>
                                    </tr>
                                </thead>
                                <tbody className="divide-y divide-slate-50">
                                    {mappings.map(m => (
                                        <tr key={m.id} className="hover:bg-slate-50 transition-colors">
                                            <td className="px-4 py-2.5 font-medium text-slate-800 text-sm">
                                                {m.collaboratorCategory}
                                            </td>
                                            <td className="px-4 py-2.5 text-slate-500 text-sm">
                                                {m.slCategoryName ?? <span className="text-slate-300">—</span>}
                                            </td>
                                            <td className="px-4 py-2.5">
                                                <StatusBadge status={m.status} />
                                            </td>
                                            <td className="px-4 py-2.5">
                                                <button
                                                    onClick={() => deleteMapping(m)}
                                                    disabled={deletingId === m.id}
                                                    className="text-xs px-2.5 py-1 rounded-md font-medium border border-transparent text-rose-500 hover:text-rose-700 hover:bg-rose-50 transition-colors disabled:opacity-40 disabled:cursor-not-allowed"
                                                >
                                                    Delete
                                                </button>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </div>
                )
            ) : (
                <Loading error={error} />
            )}
        </Layout>
    );
}
