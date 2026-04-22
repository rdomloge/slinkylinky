import { Link } from "react-router-dom";
import CategoriesCard from "./CategoriesCard";
import ArrowIcon from '@/assets/left-chevron.svg'
import { SessionBlock } from "./atoms/Button";
import Modal from "./atoms/Modal";
import { useState } from "react";
import { WarningMessage } from "./atoms/Messages";
import { fetchWithAuth } from "@/utils/fetchWithAuth";
import LinkIcon from '@/assets/link.svg';

export default function DemandSiteSearchResult({demandSite, selectedHandler, id}) {
    const hasCategories = Boolean(demandSite.categories?.some(category => category.disabled == false));
    const linkedDemandCount = demandSite.demands?.length ?? 0;

    return (
        <div className={`card list-card demandsite-card flex items-start gap-3 ${hasCategories ? '' : 'demandsite-card-warning'}`} id={id}>
            <button onClick={() => selectedHandler(demandSite)} id="select-demand-site-button"
                className="shrink-0 mt-1 p-1.5 rounded-lg transition-colors hover:bg-violet-100/70">
                <img src={ArrowIcon} alt="Select" height={20} width={20}/>
            </button>

            <div className="flex-1 min-w-0">
                <div className="flex items-start gap-3 mb-3">
                    <span className={`status-dot ${hasCategories ? 'status-dot-site' : 'status-dot-warn'}`} />
                    <div className="flex-1 min-w-0">
                        <div className="flex flex-wrap items-center gap-2 mb-2">
                            <span className="entity-badge entity-badge-demandsite">Demand Site</span>
                            <span className={`status-chip ${hasCategories ? 'status-chip-site' : 'status-chip-warn'}`}>
                                {hasCategories ? `${linkedDemandCount} demands` : 'Needs categories'}
                            </span>
                        </div>
                        <h3 className="card-title">{demandSite.name}</h3>
                    </div>
                </div>

                <div className="card-mono-row">
                    <img src={LinkIcon} alt="domain" width={12} height={12} className="opacity-60 shrink-0"/>
                    <span className="truncate">{demandSite.domain}</span>
                </div>

                {hasCategories ? (
                    <CategoriesCard categories={demandSite.categories}/>
                ) : (
                    <div className="card-warning-banner">
                        <svg className="w-3.5 h-3.5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M13 2L4 14h7l-1 8 9-12h-7l1-8z"/>
                        </svg>
                        No categories set — won&apos;t match any suppliers
                    </div>
                )}
            </div>
        </div>
    );
}

export function DemandSiteListItemLite({demandSite, id, deleteHandler}) {
    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [linkedDemands, setLinkedDemands] = useState(-1);
    const hasCategories = Boolean(demandSite.categories?.some(category => category.disabled == false));
    const linkedDemandCount = demandSite.demands?.length ?? 0;

    function handleDeleteClicked() {
        setShowDeleteModal(true);
        fetchWithAuth('/.rest/demandsites/search/countByDemandSiteId?demandSiteId=' + demandSite.id)
            .then(response => response.json())
            .then(data => setLinkedDemands(data));
    }

    function handleHistoryClicked() {
        window.location.href = '/demandsites/history?domain=' + demandSite.domain;
    }

    function doDelete() {
        deleteHandler(demandSite);
        setShowDeleteModal(false);
    }

    return (
        <div className={`card list-card demandsite-card ${hasCategories ? '' : 'demandsite-card-warning'}`} id={id}>
            <div className="flex items-start gap-3 mb-4">
                <span className={`status-dot ${hasCategories ? 'status-dot-site' : 'status-dot-warn'}`} />
                <div className="flex-1 min-w-0">
                    <div className="flex flex-wrap items-center gap-2 mb-2">
                        <span className="entity-badge entity-badge-demandsite">Demand Site</span>
                        {!hasCategories && <span className="status-chip status-chip-warn">Needs categories</span>}
                    </div>
                    <h3 className="card-title">{demandSite.name}</h3>
                </div>
                <SessionBlock>
                    <div className="flex items-center gap-3 shrink-0">
                        <Link to={'/demandsites/' + demandSite.id} rel="nofollow" className="card-action-link card-action-link-muted">
                            Edit
                        </Link>
                        <button type="button" className="card-action-link card-action-link-primary" onClick={handleHistoryClicked}>
                            History
                        </button>
                        <button type="button" className="card-action-link card-action-link-danger" onClick={handleDeleteClicked}>
                            Delete
                        </button>
                    </div>
                </SessionBlock>
            </div>

            <div className="card-mono-row">
                <img src={LinkIcon} alt="domain" width={12} height={12} className="opacity-60 shrink-0"/>
                <span className="truncate">{demandSite.domain}</span>
            </div>

            {hasCategories ? (
                <div className="mb-4">
                    <CategoriesCard categories={demandSite.categories}/>
                </div>
            ) : (
                <div className="card-warning-banner mb-4">
                    <svg className="w-3.5 h-3.5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                        <path strokeLinecap="round" strokeLinejoin="round" d="M13 2L4 14h7l-1 8 9-12h-7l1-8z"/>
                    </svg>
                    No categories set — won&apos;t match any suppliers
                </div>
            )}

            <div className="card-footer">
                <span>{hasCategories ? 'Categories assigned' : 'Missing categories'}</span>
                <div className="flex-1" />
                <span className="font-mono-data">
                    {linkedDemandCount} linked demand{linkedDemandCount === 1 ? '' : 's'}
                </span>
                {hasCategories && <span className="font-mono-data">Ready for matching</span>}
            </div>

            {showDeleteModal &&
                <Modal title="Delete Demand Site" dismissHandler={() => setShowDeleteModal(false)} width="w-1/2">
                    <p className="text-xl font-bold mb-1">{demandSite.name}</p>
                    <p className="text-sm text-slate-500 italic mb-4">{demandSite.domain}</p>
                    {linkedDemands < 0 ?
                        <p className="text-sm text-slate-500">Checking for linked demand...</p>
                    :
                        <>
                            <p className="mb-3">There are <strong>{linkedDemands}</strong> linked demands</p>
                            {linkedDemands > 0 ?
                                <WarningMessage message="You cannot delete this demand site because there are linked demands"/>
                            :
                                <button
                                    type="button"
                                    onClick={doDelete}
                                    className="px-4 py-2 rounded-lg text-sm font-semibold text-white bg-red-600 hover:bg-red-700 transition-colors"
                                >
                                    Delete
                                </button>
                            }
                        </>
                    }
                </Modal>
            }
        </div>
    );
}
