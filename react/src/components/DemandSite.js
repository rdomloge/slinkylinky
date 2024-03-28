import Link from "next/link";
import { CategoryLite } from "./category";
import Image from "next/image";
import ArrowIcon from '@/pages/demand/left-chevron.svg'
import SessionButton, { SessionBlock, StyledButton } from "./atoms/Button";
import Modal from "./atoms/Modal";
import { useState } from "react";
import { WarningMessage } from "./atoms/Messages";

export default function DemandSiteSearchResult({demandSite, selectedHandler, id}) {
    return (
        <div className="card list-card flex" id={id}>
            <div className="flex-0 pr-4 m-auto">
                <button onClick={(e) => 
                        selectedHandler(demandSite)}>
                <Image src={ArrowIcon} alt="Arrow icon" height={30} width={30} />
                </button>
            </div>
            <div className="flex-1">
                <span className="float-right bg-red-100 text-blue-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-full dark:bg-gray-700 dark:text-blue-400 border border-blue-400">
                    {demandSite.demands.length}
                </span>
                <p className="text-lg">{demandSite.name}</p>
                <p className="mb-6">{demandSite.domain}</p>
                {demandSite.categories.filter(c => c.disabled == false).map( (c,index) => <CategoryLite category={c} key={index}/> )}
            </div>
        </div>
    );
}




export function DemandSiteListItemLite({demandSite, id, deleteHandler}) {

    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [linkedDemands, setLinkedDemands] = useState(-1);

    function handleDeleteClicked() {
        setShowDeleteModal(true);

        fetch('/.rest/demandsites/search/countByDemandSiteId?demandSiteId='+demandSite.id)
        .then(response => response.json())
        .then(data => {
            setLinkedDemands(data);
        });
    }

    function doDelete() {
        deleteHandler(demandSite)
        setShowDeleteModal(false);
    }

    return (
        <div className="card list-card" id={id}>
            <div className="float-right">
                <SessionBlock>
                    <Link href={"/demandsites/"+demandSite.id}>
                        <p className='text-right'>Edit</p>
                    </Link>
                    <StyledButton isText={true} label="Delete" type="risky" extraClass="text-right" submitHandler={() => handleDeleteClicked()}/>
                </SessionBlock>
            </div>
            <p className="text-lg">{demandSite.name}</p>
            <p>{demandSite.domain}</p>
            {demandSite.categories.filter(c => c.disabled == false).map( (c,index) =>
                <CategoryLite category={c} key={index}/>
            )}
            {showDeleteModal ?
                <Modal title={"Delete Demand Site"} dismissHandler={()=>setShowDeleteModal(false)} width={"w-1/2"}>
                    <p className="text-2xl font-bold mb">{demandSite.name}</p>
                    <p className="italic mb-4">{demandSite.domain}</p>
                    {linkedDemands < 0 ?
                        <p>Checking for linked demand...</p>
                    :
                        <>
                        <p>There are {linkedDemands} linked demands</p>
                        {linkedDemands > 0 ?
                            <WarningMessage message="You cannot delete this demand site because there are linked demands" />
                        :
                            <StyledButton label="Delete" type="risky" submitHandler={() => {doDelete()}}/>
                        }
                        </>
                    }
                </Modal>
            : 
                null
            }
        </div>
    );
}