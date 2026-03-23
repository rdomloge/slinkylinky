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
import { useState, useRef } from 'react'
import { createPortal } from 'react-dom'


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
            className="bg-white rounded-xl border border-gray-200 shadow-2xl p-4 pointer-events-none"
        >
            <p className="text-sm font-semibold text-gray-800 mb-2 truncate">{supplier.domain || supplier.name}</p>
            <div className="flex flex-wrap gap-2 mb-3">
                <span className="inline-flex items-center gap-1 bg-blue-50 text-blue-700 text-xs font-semibold px-2.5 py-1 rounded-full">
                    <img src={DaIcon} alt="DA" width={11} height={11}/>
                    DA {supplier.da}
                </span>
                {supplier.weWriteFee &&
                    <span className="inline-flex items-center gap-1 bg-gray-100 text-gray-600 text-xs font-medium px-2.5 py-1 rounded-full">
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

export function SupplierCardHorizontalRowLayout({supplier, linkable, responsiveness}) {
    const [anchorRect, setAnchorRect] = useState(null);
    const trafficRef = useRef(null);

    function handleMouseEnter() {
        if (trafficRef.current) setAnchorRect(trafficRef.current.getBoundingClientRect());
    }

    function handleMouseLeave() {
        setAnchorRect(null);
    }

    return (
        <div className="flex items-center gap-4 px-4 py-3 border-b border-gray-100 hover:bg-gray-50 transition-colors">

            {/* Domain + badges */}
            <div className="w-56 shrink-0 min-w-0">
                {linkable ? (
                    <Link to={addProtocol(supplier.website)} target='_blank' rel='nofollow'
                          className="text-sm font-semibold text-blue-600 hover:underline truncate block">
                        {supplier.website}
                    </Link>
                ) : (
                    <span className="text-sm font-semibold text-gray-800 truncate block">{supplier.website}</span>
                )}
                <div className="flex flex-wrap gap-1 mt-0.5">
                    {supplier.thirdParty &&
                        <span className="text-xs bg-sky-50 text-sky-700 px-1.5 py-0.5 rounded-full border border-sky-200">3rd party</span>
                    }
                    {supplier.disabled &&
                        <span className="text-xs bg-gray-100 text-gray-400 px-1.5 py-0.5 rounded-full">Disabled</span>
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
                <span className="inline-flex items-center bg-blue-50 text-blue-700 text-xs font-semibold px-2 py-1 rounded-full">
                    DA {supplier.da}
                </span>
            </div>

            {/* Fee */}
            <div className="w-24 shrink-0">
                {supplier.weWriteFee ? (
                    <span className="text-sm font-medium text-gray-700">
                        {supplier.weWriteFeeCurrency}{supplier.weWriteFee}
                    </span>
                ) : (
                    <span className="text-xs text-gray-400">—</span>
                )}
            </div>

            {/* Responsiveness */}
            <div className="w-28 shrink-0">
                <ResponsivenessLabel avgResponseDays={responsiveness?.avgResponseDays} />
            </div>

            {/* Edit */}
            <div className="w-10 shrink-0 text-right">
                <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                    <Link to={'/supplier/' + supplier.id} rel='nofollow'
                          className="text-xs text-gray-400 hover:text-blue-600 transition-colors">
                        Edit
                    </Link>
                </AuthorizedAccess>
            </div>
        </div>
    )
}

export default function SupplierCard({supplier, editable, linkable, usages, responsiveness, latest = true, id, showCategories = true, showSemRushTraffic = true}) {

    return (
        <div id={id} className="card list-card relative">

            {/* Header: name + badges + edit */}
            <div className="flex items-start justify-between gap-2 mb-3">
                <div className="flex items-center flex-wrap gap-2 min-w-0">
                    <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                        <span id="supplier-name" className={`text-base font-semibold leading-snug ${supplier.disabled ? 'text-gray-300' : 'text-gray-900'}`}>
                            {supplier.name}
                        </span>
                    </AuthorizedAccess>
                    {!latest &&
                        <span className="inline-flex items-center bg-amber-50 text-amber-700 text-xs font-medium px-2 py-0.5 rounded-full border border-amber-200">
                            Updated
                        </span>
                    }
                    {supplier.thirdParty &&
                        <span className="inline-flex items-center bg-sky-50 text-sky-700 text-xs font-medium px-2 py-0.5 rounded-full border border-sky-200">
                            3rd party
                        </span>
                    }
                </div>
                {editable &&
                    <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                        <Link to={'/supplier/'+supplier.id} rel='nofollow'>
                            <span id="supplier-editbtn-id" className="text-sm text-gray-400 hover:text-gray-700 shrink-0">Edit</span>
                        </Link>
                    </AuthorizedAccess>
                }
            </div>

            {/* Website + Email */}
            <div className="space-y-1 mb-3">
                {linkable ? (
                    <Link to={addProtocol(supplier.website)} className="flex items-center gap-2 text-sm text-blue-600 hover:underline" target='_blank' rel='nofollow'>
                        <img src={LinkIcon} alt="link" width={13} height={13} className="shrink-0 opacity-70"/>
                        <span className="truncate">{supplier.website}</span>
                    </Link>
                ) : (
                    <div className="flex items-center gap-2 text-sm text-gray-600">
                        <img src={LinkIcon} alt="link" width={13} height={13} className="shrink-0 opacity-60"/>
                        <span className="truncate">{supplier.website}</span>
                    </div>
                )}
                <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                    {linkable ? (
                        <Link to={'mailto:'+supplier.email} className="flex items-center gap-2 text-sm text-blue-600 hover:underline" rel='nofollow'>
                            <img src={EmailIcon} alt="email" width={13} height={13} className="shrink-0 opacity-70"/>
                            <span id="supplier-email" className="truncate">{supplier.email}</span>
                        </Link>
                    ) : (
                        <div className="flex items-center gap-2 text-sm text-gray-500">
                            <img src={EmailIcon} alt="email" width={13} height={13} className="shrink-0 opacity-60"/>
                            <span id="supplier-email" className="truncate">{supplier.email}</span>
                        </div>
                    )}
                </AuthorizedAccess>
            </div>

            {/* Stat chips */}
            <div className="flex items-center flex-wrap gap-2 mb-3">
                <span className="inline-flex items-center gap-1.5 bg-blue-50 text-blue-700 text-xs font-semibold px-2.5 py-1 rounded-full">
                    <img src={DaIcon} alt="DA" width={11} height={11}/>
                    DA {supplier.da}
                </span>
                {supplier.weWriteFee &&
                    <span className="inline-flex items-center gap-1.5 bg-gray-100 text-gray-600 text-xs font-medium px-2.5 py-1 rounded-full">
                        <img src={MoneyIcon} alt="fee" width={11} height={11}/>
                        {supplier.weWriteFeeCurrency}{supplier.weWriteFee}
                    </span>
                }
                {usages &&
                    <Counter count={usages[supplier.id]} low={2} medium={5} high={25}/>
                }
                {responsiveness && responsiveness[supplier.id] &&
                    <ResponsivenessLabel avgResponseDays={responsiveness[supplier.id].avgResponseDays} />
                }
            </div>

            {/* Categories */}
            {showCategories &&
                <CategoriesCard categories={supplier.categories}/>
            }

            {/* Footer: source + traffic graph */}
            {showSemRushTraffic &&
                <div className="mt-3 pt-3 border-t border-gray-100">
                    <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                        {supplier.source &&
                            <div className="flex items-center gap-1.5 text-xs text-gray-400 mb-2">
                                <img src={EnterIcon} alt="source" width={12} height={12} className="opacity-60"/>
                                <span id="supplier-source">{supplier.source}</span>
                            </div>
                        }
                    </AuthorizedAccess>
                    <SupplierSemRushTraffic supplier={supplier}/>
                </div>
            }
        </div>
    )
}
