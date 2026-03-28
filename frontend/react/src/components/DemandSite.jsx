import { Link } from "react-router-dom";
import CategoriesCard from "./CategoriesCard";
import ArrowIcon from '@/assets/left-chevron.svg'
import { SessionBlock, StyledButton } from "./atoms/Button";
import Modal from "./atoms/Modal";
import { useState } from "react";
import { WarningMessage } from "./atoms/Messages";
import { fetchWithAuth } from "@/utils/fetchWithAuth";
import LinkIcon from '@/assets/link.svg';

export default function DemandSiteSearchResult({demandSite, selectedHandler, id}) {
    return (
        <div className="card list-card flex items-center gap-3" id={id}>

            {/* Select button */}
            <button onClick={() => selectedHandler(demandSite)} id="select-demand-site-button"
                className="shrink-0 p-1.5 rounded-lg hover:bg-slate-100 transition-colors">
                <img src={ArrowIcon} alt="Select" height={20} width={20}/>
            </button>

            {/* Content */}
            <div className="flex-1 min-w-0">
                <div className="flex items-start justify-between gap-2 mb-1">
                    <span className="text-base font-semibold text-slate-900">{demandSite.name}</span>
                    <span className="inline-flex items-center bg-slate-100 text-slate-600 text-xs font-medium px-2 py-0.5 rounded-full shrink-0">
                        {demandSite.demands.length} demands
                    </span>
                </div>
                <div className="flex items-center gap-1.5 text-sm text-slate-500 mb-2">
                    <img src={LinkIcon} alt="domain" width={12} height={12} className="opacity-60 shrink-0"/>
                    <span className="truncate">{demandSite.domain}</span>
                </div>
                <CategoriesCard categories={demandSite.categories}/>
            </div>
        </div>
    );
}

export function DemandSiteListItemLite({demandSite, id, deleteHandler}) {

    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [linkedDemands, setLinkedDemands] = useState(-1);

    function handleDeleteClicked() {
        setShowDeleteModal(true);
        fetchWithAuth('/.rest/demandsites/search/countByDemandSiteId?demandSiteId='+demandSite.id)
            .then(response => response.json())
            .then(data => setLinkedDemands(data));
    }

    function handleHistoryClicked() {
        window.location.href = '/demandsites/history?domain='+demandSite.domain;
    }

    function doDelete() {
        deleteHandler(demandSite);
        setShowDeleteModal(false);
    }

    return (
        <div className="card list-card" id={id}>

            {/* Header: name + actions */}
            <div className="flex items-start justify-between gap-2 mb-2">
                <span className="text-base font-semibold text-slate-900">{demandSite.name}</span>
                <SessionBlock>
                    <div className="flex items-center gap-3 shrink-0 text-sm">
                        <Link to={'/demandsites/'+demandSite.id} rel="nofollow">
                            <span className="text-slate-400 hover:text-slate-700">Edit</span>
                        </Link>
                        <StyledButton isText={true} label="History" type="tertiary" submitHandler={handleHistoryClicked}/>
                        <StyledButton isText={true} label="Delete" type="risky" submitHandler={handleDeleteClicked}/>
                    </div>
                </SessionBlock>
            </div>

            {/* Domain */}
            <div className="flex items-center gap-1.5 text-sm text-slate-500 mb-3">
                <img src={LinkIcon} alt="domain" width={12} height={12} className="opacity-60 shrink-0"/>
                <span className="truncate">{demandSite.domain}</span>
            </div>

            {/* Categories */}
            <CategoriesCard categories={demandSite.categories}/>

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
                                <StyledButton label="Delete" type="risky" submitHandler={doDelete}/>
                            }
                        </>
                    }
                </Modal>
            }
        </div>
    );
}
