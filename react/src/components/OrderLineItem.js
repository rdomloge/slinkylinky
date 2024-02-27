import Link from "next/link"
import { useEffect, useState } from "react"


export default function OrderLineItem({lineItem}) {

    const [demandDescription, setDemandDescription] = useState()
    const [demandError, setDemandError] = useState()
    const [supplierDescription, setSupplierDescription] = useState()
    const [proposalTitle, setProposalTitle] = useState()

    useEffect( () => {
        fetch("/.rest/demands/"+lineItem.demandId)
            .then((res) => res.json())
            .then((result)=> setDemandDescription(result.name))
            .catch((error)=>{
                console.log("Can't fetch demand. Is the Demand service running?")
                setDemandError("Can't fetch demand. Is the Demand service running?")
        ***REMOVED***)

        if(lineItem.linkedProposalId) {
            fetch("/.rest/proposals/"+lineItem.linkedProposalId+"?projection=fullProposal")
                .then((res) => res.json())
                .then((result)=> {
                    setSupplierDescription(result.paidLinks[0].supplier.domain)
                    setProposalTitle(result.liveLinkTitle)
            ***REMOVED***)
                .catch((error)=>{
                    console.log("Can't fetch proposals. Is the Proposal service running?")
            ***REMOVED***)
    ***REMOVED***
***REMOVED***,[lineItem]);

    


    return (
        <ol className="items-center grid grid-cols-3">
            <LineItemStep title={"Demand created"} date={lineItem.dateCreated} description={""}
                linkText={demandDescription} linkUrl={ lineItem.linkedProposalId ? "/proposals/"+lineItem.linkedProposalId : "/supplier/search/" + lineItem.demandId}/> 
            {lineItem.linkedProposalId ? 
                <LineItemStep title={"Matched"} date={lineItem.dateProposalCreated} description={""} 
                    linkText={supplierDescription} linkUrl={"/proposals/"+lineItem.linkedProposalId}/>
            :
                null
        ***REMOVED***
            {lineItem.proposalComplete ? 
                <LineItemStep title={"Delivered"} date={""} description={""}
                    linkText={proposalTitle} linkUrl={"/proposals/"+lineItem.linkedProposalId}/>
            :
                null
        ***REMOVED***
        </ol>
    )
}

function LineItemStep({title, date, description, linkText, linkUrl}) {
    return (
        <li className="relative mb-6 sm:mb-0 mt-2 ">
            <div className="flex items-center">
                <div className="z-10 flex items-center justify-center w-6 h-6 bg-blue-100 rounded-full ring-0 ring-white dark:bg-blue-900 sm:ring-8 dark:ring-gray-900 shrink-0">
                    <svg className="w-2.5 h-2.5 text-blue-800 dark:text-blue-300" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M20 4a2 2 0 0 0-2-2h-2V1a1 1 0 0 0-2 0v1h-3V1a1 1 0 0 0-2 0v1H6V1a1 1 0 0 0-2 0v1H2a2 2 0 0 0-2 2v2h20V4ZM0 18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8H0v10Zm5-8h10a1 1 0 0 1 0 2H5a1 1 0 0 1 0-2Z"/>
                    </svg>
                </div>
                <div className="hidden sm:flex w-full bg-gray-200 h-0.5 dark:bg-gray-700"></div>
            </div>
            <div className="mt-3 sm:pe-8">
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white">{title}</h3>
                <time className="block mb-2 text-sm font-normal leading-none text-gray-400 dark:text-gray-500">{date}</time>
                {linkText && linkUrl ?
                    <p className="text-base font-normal text-gray-500 dark:text-gray-400 truncate">{description} <Link href={linkUrl}>{linkText}</Link></p>
                :
                    <p className="text-base font-normal text-gray-500 dark:text-gray-400">{description}</p>
            ***REMOVED***
            </div>
        </li>        
    )
}