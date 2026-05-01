import CategoriesCard from '@/components/CategoriesCard'
import DaIcon from '@/assets/authority.svg'
import LinkIcon from '@/assets/link.svg'
import EmailIcon from '@/assets/email.svg'
import MoneyIcon from '@/assets/tag.svg'
import EnterIcon from '@/assets/enter.svg'
import { Link } from 'react-router-dom'
import Counter from './Counter'
import ResponsivenessLabel from './ResponsivenessLabel'
import SupplierSemRushTraffic from './SupplierStats'
import { addProtocol } from './Util'
import { AuthorizedAccess } from './AuthorizedAccess'
import { useState, useRef, useEffect } from 'react'
import { createPortal } from 'react-dom'
import { fetchWithAuth } from '@/utils/fetchWithAuth'


function SupplierStatsPopover({ supplier, anchor }) {
    const popoverWidth = 300;
    const fitsRight = anchor.right + 16 + popoverWidth < window.innerWidth;
    const left = fitsRight ? anchor.right + 12 : anchor.left - popoverWidth - 12;
    const top = Math.max(8, Math.min(
        anchor.top + anchor.height / 2,
        window.innerHeight - 320
    ));

    return createPortal(
        <div
            style={{ position: 'fixed', top, left, transform: 'translateY(-50%)', zIndex: 9999, width: popoverWidth }}
            className="bg-white rounded-xl border border-slate-200 shadow-2xl p-4 pointer-events-none"
        >
            <p className="text-sm font-semibold text-slate-800 mb-2 truncate">{supplier.domain || supplier.name}</p>
            <div className="flex flex-wrap gap-2 mb-3">
                <span className="inline-flex items-center gap-1 bg-indigo-50 text-indigo-700 text-xs font-semibold px-2.5 py-1 rounded-full">
                    <img src={DaIcon} alt="DA" width={11} height={11}/>
                    DA {supplier.da}
                </span>
                {supplier.weWriteFee &&
                    <span className="inline-flex items-center gap-1 bg-slate-100 text-slate-600 text-xs font-medium px-2.5 py-1 rounded-full">
                        <img src={MoneyIcon} alt="fee" width={11} height={11}/>
                        {supplier.weWriteFeeCurrency}{supplier.weWriteFee}
                    </span>
                }
            </div>
            <SupplierSemRushTraffic supplier={supplier} showTrafficAnalysis={false} showSpamScore={true}/>
        </div>,
        document.body
    );
}

function ExcludeButton({ supplierId }) {
    const [excluded, setExcluded] = useState(null);

    useEffect(() => {
        fetchWithAuth(`/.rest/supplierExclusions/isExcluded?supplierId=${supplierId}`)
            .then(r => r?.ok ? r.json() : null)
            .then(v => { if (v !== null) setExcluded(v); })
            .catch(() => {});
    }, [supplierId]);

    function toggle() {
        const method = excluded ? 'DELETE' : 'POST';
        const endpoint = excluded ? 'unexclude' : 'exclude';
        fetchWithAuth(`/.rest/supplierExclusions/${endpoint}?supplierId=${supplierId}`, { method })
            .then(r => { if (r?.ok || r?.status === 204 || r?.status === 201) setExcluded(!excluded); })
            .catch(() => {});
    }

    if (excluded === null) return null;

    return (
        <button
            onClick={toggle}
            title={excluded ? 'Un-exclude supplier for your org' : 'Exclude supplier from your org\'s matching'}
            className={`flex items-center justify-center transition-all duration-200 ${
                excluded
                    ? 'text-amber-600 hover:text-amber-700'
                    : 'text-slate-400 hover:text-slate-600'
            }`}
        >
            {excluded ? (
                // Excluded state: prohibition circle icon
                <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                    <circle cx="12" cy="12" r="10" />
                    <path d="M7 12h10" strokeLinecap="round" />
                </svg>
            ) : (
                // Exclude state: eye-off icon (hidden/excluded concept)
                <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M3.98 8.223A10.477 10.477 0 0 0 1.934 12C3.226 16.338 7.244 19.5 12 19.5c.993 0 1.953-.138 2.863-.395M6.228 6.228A10.45 10.45 0 0 1 12 4.5c4.756 0 8.773 3.162 10.065 7.498a10.523 10.523 0 0 1-4.293 5.774M6.228 6.228 3 3m3.228 3.228 3.65 3.65m7.894 7.894L21 21m-3.228-3.228-3.65-3.65m0 0a3 3 0 1 0-4.243-4.243m4.242 4.242L9.88 9.88" />
                </svg>
            )}
        </button>
    );
}

export function SupplierCardHorizontalRowLayout({supplier, linkable, responsiveness, usageCount, showActions}) {
    const [anchorRect, setAnchorRect] = useState(null);
    const trafficRef = useRef(null);

    function handleMouseEnter() {
        if (trafficRef.current) setAnchorRect(trafficRef.current.getBoundingClientRect());
    }

    function handleMouseLeave() {
        setAnchorRect(null);
    }

    return (
        <div className="flex items-center gap-4 px-4 py-3 border-b hover:bg-emerald-50/30 transition-colors" style={{borderColor: 'var(--supplier-border)'}}>

            {/* Domain + badges */}
            <div className="w-56 shrink-0 min-w-0">
                {linkable ? (
                    <Link to={addProtocol(supplier.website)} target='_blank' rel='nofollow'
                          className="text-sm font-semibold hover:underline truncate block" style={{color: 'var(--supplier-color)'}}>
                        {supplier.website}
                    </Link>
                ) : (
                    <span className="text-sm font-semibold text-slate-800 truncate block">{supplier.website}</span>
                )}
                <div className="flex flex-wrap gap-1 mt-0.5">
                    {supplier.thirdParty &&
                        <span className="text-xs bg-sky-50 text-sky-700 px-1.5 py-0.5 rounded-full border border-sky-200">3rd party</span>
                    }
                    {supplier.disabled &&
                        <span className="text-xs bg-slate-100 text-slate-400 px-1.5 py-0.5 rounded-full">Disabled</span>
                    }
                </div>
            </div>

            {/* Categories */}
            <div className="flex-1 min-w-0">
                <CategoriesCard categories={supplier.categories}/>
            </div>

            {/* Traffic — hover reveals full stats popover */}
            <div
                ref={trafficRef}
                className="w-36 shrink-0 cursor-default"
                onMouseEnter={handleMouseEnter}
                onMouseLeave={handleMouseLeave}
            >
                <SupplierSemRushTraffic supplier={supplier} compact={true} showSpamScore={true}/>
            </div>
            {anchorRect && <SupplierStatsPopover supplier={supplier} anchor={anchorRect}/>}

            {/* DA */}
            <div className="w-16 shrink-0 text-center">
                <span className="stat-chip-supplier font-mono-data">
                    DA {supplier.da}
                </span>
            </div>

            {/* Fee */}
            <div className="w-24 shrink-0">
                {supplier.weWriteFee ? (
                    <span className="text-sm font-medium text-slate-700">
                        {supplier.weWriteFeeCurrency}{supplier.weWriteFee}
                    </span>
                ) : (
                    <span className="text-xs text-slate-400">—</span>
                )}
            </div>

            {/* Usages */}
            <div className="w-16 shrink-0 text-center">
                {usageCount != null && <Counter count={usageCount} low={2} medium={5} high={25}/>}
            </div>

            {/* Responsiveness */}
            <div className="w-40 shrink-0">
                <ResponsivenessLabel avgResponseDays={responsiveness?.avgResponseDays} />
            </div>

            {/* Actions: Exclude / Edit */}
            {showActions && (
            <div className="flex items-center gap-2 shrink-0">
                <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                    <ExcludeButton supplierId={supplier.id} />
                </AuthorizedAccess>
                <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                    <Link to={'/supplier/' + supplier.id} rel='nofollow'
                          title="Edit supplier"
                          className="flex items-center justify-center w-7 h-7 rounded-full bg-slate-100 hover:bg-indigo-100 text-slate-500 hover:text-indigo-600 transition-all duration-200">
                        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M11 5H6a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h11a2 2 0 0 0 2-2v-5m-1.414-9.414a2 2 0 1 1 2.828 2.828L9.172 19H7v-2.172l9.414-9.414z" />
                        </svg>
                    </Link>
                </AuthorizedAccess>
            </div>
            )}
        </div>
    )
}

export default function SupplierCard({supplier, editable, linkable, usages, responsiveness, latest = true, id, showCategories = true, showSemRushTraffic = true, selectHandler}) {
    const responseMeta = responsiveness?.[supplier.id];
    const supplierTitle = supplier.name || supplier.website || supplier.domain;

    return (
        <div id={id} className="card list-card supplier-card relative">
            <div className="flex items-start gap-3 mb-4">
                <span className="status-dot status-dot-supplier" />
                <div className="flex-1 min-w-0">
                    <div className="flex items-center flex-wrap gap-2 mb-2">
                        <span className="entity-badge entity-badge-supplier">Supplier</span>
                        {responseMeta && <ResponsivenessLabel avgResponseDays={responseMeta.avgResponseDays} />}
                        {!latest && <span className="status-chip status-chip-neutral">Updated</span>}
                        {supplier.thirdParty && <span className="status-chip status-chip-neutral">3rd party</span>}
                        {supplier.disabled && <span className="status-chip status-chip-danger">Disabled</span>}
                    </div>
                    <h3 className={`card-title ${supplier.disabled ? 'text-slate-300' : ''}`}>{supplierTitle}</h3>
                </div>
                <div className="flex items-center gap-3 shrink-0">
                    {selectHandler && (
                        <button id="supplier-selectbtn-id" onClick={selectHandler} className="card-filled-action card-filled-action-supplier">
                            Select
                        </button>
                    )}
                    {editable &&
                        <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                            <Link to={'/supplier/' + supplier.id} rel='nofollow' id="supplier-editbtn-id" className="card-action-link card-action-link-muted">
                                Edit
                            </Link>
                        </AuthorizedAccess>
                    }
                </div>
            </div>

            <div className="card-mono-row">
                <img src={LinkIcon} alt="link" width={13} height={13} className="shrink-0 opacity-60"/>
                {linkable ? (
                    <Link
                        to={addProtocol(supplier.website)}
                        className="truncate hover:underline"
                        style={{ color: 'var(--supplier-color)' }}
                        target='_blank'
                        rel='nofollow'
                    >
                        {supplier.website}
                    </Link>
                ) : (
                    <span className="truncate">{supplier.website}</span>
                )}
            </div>

            <AuthorizedAccess allowedRoles={['global_admin']}>
                {supplier.email && (
                    linkable ? (
                        <Link to={'mailto:' + supplier.email} className="flex items-center gap-2 text-sm hover:underline mb-3" style={{ color: 'var(--supplier-color)' }} rel='nofollow'>
                            <img src={EmailIcon} alt="email" width={13} height={13} className="shrink-0 opacity-60"/>
                            <span id="supplier-email" className="truncate">{supplier.email}</span>
                        </Link>
                    ) : (
                        <div className="flex items-center gap-2 text-sm text-slate-500 mb-3">
                            <img src={EmailIcon} alt="email" width={13} height={13} className="shrink-0 opacity-60"/>
                            <span id="supplier-email" className="truncate">{supplier.email}</span>
                        </div>
                    )
                )}
            </AuthorizedAccess>

            <div className="flex flex-wrap gap-2 mb-4">
                <span className="metric-pill metric-pill-supplier">
                    <span className="metric-pill-label">DA</span>
                    <span>{supplier.da}</span>
                </span>
                {supplier.weWriteFee &&
                    <span className="metric-pill metric-pill-neutral">
                        <span className="metric-pill-label">Fee</span>
                        <span>{supplier.weWriteFeeCurrency}{supplier.weWriteFee}</span>
                    </span>
                }
                {usages && usages[supplier.id] != null &&
                    <span className="metric-pill metric-pill-neutral">
                        <span className="metric-pill-label">Uses</span>
                        <span>{usages[supplier.id]}</span>
                    </span>
                }
            </div>

            {showCategories &&
                <div className="mb-4">
                    <CategoriesCard categories={supplier.categories}/>
                </div>
            }

            {showSemRushTraffic &&
                <div className="mt-3">
                    <div className="card-footer">
                        <AuthorizedAccess allowedRoles={['global_admin']}>
                            {supplier.source && (
                                <span className="inline-flex items-center gap-1.5 min-w-0">
                                    <img src={EnterIcon} alt="source" width={12} height={12} className="opacity-60 shrink-0"/>
                                    <span id="supplier-source" className="truncate">{supplier.source}</span>
                                </span>
                            )}
                        </AuthorizedAccess>
                        <div className="flex-1" />
                        {responseMeta?.avgResponseDays != null && (
                            <span className="font-mono-data">Avg response {responseMeta.avgResponseDays.toFixed(1)}d</span>
                        )}
                    </div>
                    <div className="pt-3">
                        <SupplierSemRushTraffic supplier={supplier}/>
                    </div>
                </div>
            }
        </div>
    )
}
