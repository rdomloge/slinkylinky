'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout/Layout'
import SupplierCard from '@/components/suppliercard'
import DemandCard from '@/components/demandcard'
import TrafficLights from '@/components/ProposalTrafficLights'
import NiceDate from '@/components/atoms/DateTime'
import Link from 'next/link'
import Loading from '@/components/Loading'
import { StyledButton } from '@/components/atoms/Button'
import Modal from '@/components/atoms/Modal'
import { useSession } from 'next-auth/react'
import DotMenu from '@/components/atoms/DotMenu'
import TextInput from '@/components/atoms/TextInput'
import LabeledText from '@/components/atoms/LabeledText'

export default function Proposal() {
    const router = useRouter()
    const [proposal, setProposal] = useState()
    const [supplier, setSupplier] = useState()
    const [demands, setDemands] = useState()
    const [error, setError] = useState(null)
    const [showAbortModal, setShowAbortModal] = useState(false)
    const { data: session } = useSession();
    const [showInvoiceDownloadModal, setShowInvoiceDownloadModal] = useState(false);
    const [engagement, setEngagement] = useState();
    const [invoiceError, setInvoiceError] = useState(null);
    const [showPreviewModal, setShowPreviewModal] = useState(false)
    const [currentSupplier, setCurrentSupplier] = useState()

    useEffect(
        () => {
            if(router.isReady) {
                const proposalsUrl = "/.rest/proposals/"+router.query.proposalid+"?projection=fullProposal";
                fetch(proposalsUrl, {headers: {'Cache-Control': 'no-cache'}})
                    .then( (res) => {
                        if(res.status == 404) {
                            throw new Error("Proposal not found")
                    ***REMOVED***
                        return res.json()
                ***REMOVED***)
                    .then( (p) => {
                        setProposal(p);
                        setDemands(p.paidLinks.map(pl => pl.demand))
                        if(p.supplierSnapshotVersion != p.paidLinks[0].supplier.version) {
                            setCurrentSupplier(p.paidLinks[0].supplier); 
                            // load the version of the supplier that was current at the time of the proposal
                            const url = "/.rest/supplierSupport/getVersion?supplierId="+p.paidLinks[0].supplier.id+"&projection=fullSupplier"
                                        +"&version="+p.supplierSnapshotVersion
                            fetch(url, {headers: {'Cache-Control': 'no-cache'}})
                                .then( (res) => res.json())
                                .then( (s) => setSupplier(s)) 
                    ***REMOVED***
                        else {
                            setSupplier(p.paidLinks[0].supplier);
                    ***REMOVED***
                ***REMOVED***)
                    .catch( (err) => setError(err.message));
        ***REMOVED***
    ***REMOVED***, [router.isReady, router.query.proposalid]);
    
    function abortProposal() {
        const url = "/.rest/proposalsupport/abort?proposalId="+router.query.proposalid;
        fetch(url, {
                method: 'DELETE', 
                headers: {'user': session.user.email}})
            .then( (res) => {
                if(res.ok) {
                    router.push('/proposals');
            ***REMOVED***
        ***REMOVED***)
            .catch( (err) => setError(err.message));
***REMOVED***

    function loadEngagement() {
        const url = "/.rest/engagements/search/findByProposalIdAndStatusACCEPTED?proposalId="+router.query.proposalid;
        fetch(url)
            .then( (res) => res.json())
            .then( (e) => setEngagement(e))
            .catch( (err) => {
                setInvoiceError(err.message)
        ***REMOVED***);
***REMOVED***

    function createMenuItems() {
        const items = [];
        if(proposal) {
            if(proposal.invoiceReceived) {
                items.push({label: 'Download invoice', onClick: () => {
                    setShowInvoiceDownloadModal(true)
                    loadEngagement();
            ***REMOVED******REMOVED***
        ***REMOVED***
            if(proposal.contentReady) {
                items.push({label: 'View article', onClick: () => { 
                    setShowPreviewModal(true);
            ***REMOVED******REMOVED***
        ***REMOVED***
            items.push({label: 'Abort', onClick: () => setShowAbortModal(true)***REMOVED***
    ***REMOVED***
        return items;
***REMOVED***

    return (
            <Layout>
                
                <PageTitle title="Proposal"/>
                {proposal ?
                    <>
                    <div><NiceDate isostring={proposal.dateCreated}/></div>
                    <div className="float-right p-2 m-2">
                        
                    </div>
                    <DotMenu items={createMenuItems()} classNames="float-left mt-6"/>
                    <TrafficLights proposal={proposal} updateHandler={setProposal} interactive={true}/>
                    {proposal.blogLive ?
                        <div className="card grid grid-cols-3 m-4">
                            <span className='text-center font-extrabold text-lg col-span-2'>{proposal.liveLinkTitle}</span>
                            <span className='truncate'>
                                <Link href={proposal.liveLinkUrl} className='truncate'>
                                    {proposal.liveLinkUrl}
                                </Link>
                            </span>
                        </div>
                    : null}
                    <div className="flex">
                            {supplier ?
                                <div className="flex-initial w-1/2" id="supplierPanel">
                                <SupplierCard supplier={supplier} latest={null == currentSupplier} editable={false} linkable={true} />
                                </div>
                            : 
                                null
                        ***REMOVED***
                            <div className="flex-1">
                                {demands.map( (ld,index) => <DemandCard demand={ld} key={ld.name} id={"demandcard-"+index}/>)}
                            </div>
                            
                    </div>
                    <div className="card list-card w-1/3">
                        <div className="grid grid-cols-2" id="metadata">
                            <span>Created</span> <NiceDate isostring={proposal.dateCreated}/>
                            <span>Sent to supplier</span> <NiceDate isostring={proposal.dateSentToSupplier}/>
                            <span>Accepted by supplier</span> <NiceDate isostring={proposal.dateAcceptedBySupplier}/>
                            <span>Date invoice received</span> <NiceDate isostring={proposal.dateInvoiceReceived}/>
                            <span>Date invoice paid</span> <NiceDate isostring={proposal.dateInvoicePaid}/>
                            <span>Blog live</span> <NiceDate isostring={proposal.dateBlogLive}/>
                        </div>
                    </div>
                    {showAbortModal ?
                        <Modal title={"Abort proposal"} dismissHandler={() => setShowAbortModal(false)}>
                            <p className='text-2xl font-dark py-2'>Are you sure you want to abort this proposal?</p>
                            <p>This will unlink the supplier from each demand and it will be like it never happened.</p>
                            <p>The demand will reappear in the demand list and you&apos;ll need to find a supplier for them.</p>
                            <p>This should only ever be necessary if the supplier declined or let us down.</p>
                            <div className="flex justify-end pt-4">
                                <StyledButton label='Abort' type='risky' submitHandler={() => abortProposal()} />
                            </div>
                        </Modal>
                    : 
                        null
                ***REMOVED***
                    {showInvoiceDownloadModal ?
                        <Modal title={"Download invoice"} dismissHandler={() => setShowInvoiceDownloadModal(false)} width={"w-1/3"}>
                            {engagement ?
                                <>
                                <LabeledText label="Filename" text={engagement.invoiceFileName} textClasses={"text-2xl"}/>
                                <LabeledText label="File type" text={engagement.invoiceFileContentType} />
                                <div className="flex justify-end pt-4">
                                    <Link href={"/.rest/engagements/downloadInvoice?proposalId="+engagement.proposalId} target='_blank'>
                                        Download
                                    </Link>
                                </div>
                                </>
                            : 
                                null
                        ***REMOVED***
                            
                            {invoiceError ?
                                <>
                                <p className='text-2xl font-dark py-2'>Error</p>
                                <p className='font-dark pb-2'>{invoiceError}</p>
                                </>
                            : 
                                null
                        ***REMOVED***
                            
                        </Modal>
                    : 
                        null
                ***REMOVED***
                    {showPreviewModal ?
                        <Modal title="Article" dismissHandler={() => { setShowPreviewModal(false) }} width="w-2/3">
                            <iframe src={"/.rest/proposalsupport/getArticleFormatted?proposalId=" + router.query.proposalid} width="100%" height={480} />
                        </Modal>
                        :
                        null
                ***REMOVED***
                    </>
                :
                    <Loading error={error}/>
            ***REMOVED***
            </Layout>
    );
}