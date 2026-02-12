import React, {useState, useEffect} from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout/Layout'
import SupplierCard from '@/components/suppliercard'
import DemandCard from '@/components/demandcard'
import TrafficLights from '@/components/ProposalTrafficLights'
import NiceDate from '@/components/atoms/DateTime'
import { Link } from 'react-router-dom'
import Loading from '@/components/Loading'
import { StyledButton } from '@/components/atoms/Button'
import Modal from '@/components/atoms/Modal'
import { useAuth } from '@/auth/AuthProvider'
import DotMenu from '@/components/atoms/DotMenu'
import LabeledText from '@/components/atoms/LabeledText'
import { addProtocol } from '@/components/Util'
import Timer from "@/pages/proposals/timer.svg";
import DoNotExpire from "@/pages/proposals/expired.svg";
import AddOrEditDemand from '@/components/AddOrEditDemand'
import { fetchWithAuth } from '@/utils/fetchWithAuth'


export default function Proposal() {
    const { proposalid } = useParams()
    const navigate = useNavigate()
    const [proposal, setProposal] = useState()
    const [supplier, setSupplier] = useState()
    const [demands, setDemands] = useState()
    const [error, setError] = useState(null)
    const [showAbortModal, setShowAbortModal] = useState(false)
    const { user } = useAuth();
    const [showInvoiceDownloadModal, setShowInvoiceDownloadModal] = useState(false);
    const [engagement, setEngagement] = useState();
    const [invoiceError, setInvoiceError] = useState(null);
    const [showPreviewModal, setShowPreviewModal] = useState(false)
    const [currentSupplier, setCurrentSupplier] = useState()
    const [showEditDemandModal, setShowEditDemandModal] = useState(false)
    const [demandBeingEdited, setDemandBeingEdited] = useState()

    useEffect(
        () => {
            const proposalsUrl = "/.rest/proposals/"+proposalid+"?projection=fullProposal";
            fetchWithAuth(proposalsUrl, {headers: {'Cache-Control': 'no-cache'}})
                .then( (res) => {
                    if(res.status == 404) {
                        throw new Error("Proposal not found")
                    }
                    return res.json()
                })
                .then( (p) => {
                    setProposal(p);
                    setDemands(p.paidLinks.map(pl => pl.demand))
                    if(p.proposalSent) {
                        loadEngagement();
                    }
                    if(p.supplierSnapshotVersion != p.paidLinks[0].supplier.version) {
                        setCurrentSupplier(p.paidLinks[0].supplier);
                        // load the version of the supplier that was current at the time of the proposal
                        const url = "/.rest/supplierSupport/getVersion?supplierId="+p.paidLinks[0].supplier.id+"&projection=fullSupplier"
                                    +"&version="+p.supplierSnapshotVersion
                        fetchWithAuth(url, {headers: {'Cache-Control': 'no-cache'}})
                            .then( (res) => res.json())
                            .then( (s) => setSupplier(s))
                    }
                    else {
                        setSupplier(p.paidLinks[0].supplier);
                    }
                })
                .catch( (err) => setError(err.message));
        }, [proposalid]);
    
    function abortProposal() {
        const url = "/.rest/proposalsupport/abort?proposalId="+proposalid;
        fetchWithAuth(url, {
                method: 'DELETE',
                headers: {'user': user.email}})
            .then( (res) => {
                if(res.ok) {
                    navigate('/proposals');
                }
            })
            .catch( (err) => setError(err.message));
    }

    function loadEngagement() {
        const url = "/.rest/engagements/search/findByProposalIdAndStatusACCEPTED?proposalId="+proposalid;
        fetchWithAuth(url)
            .then( (res) => res.json())
            .then( (e) => setEngagement(e))
            .catch( (err) => {
                setInvoiceError(err.message)
            });
    }

    function setDoNotExpire() {
        const url = "/.rest/proposals/"+proposalid;
        const payload  = {doNotExpire: true, updatedBy: user.email};
        fetchWithAuth(url, {method: 'PATCH', body: JSON.stringify(payload), headers: {'Content-Type': 'application/json'}})
            .then( (res) => {
                if(res.ok) {
                    setProposal({...proposal, doNotExpire: true});
                }
            })
            .catch( (err) => setError(err.message));
    }

    function editDemand(demand) {
        setDemandBeingEdited(demand);
        setShowEditDemandModal(true);
    }


    function createMenuItems() {
        const items = [];
        if(proposal) {
            if(proposal.invoiceReceived) {
                items.push({label: 'View invoice', onClick: () => {
                    // setShowInvoiceDownloadModal(true)
                    // loadEngagement();
                    
                    const url = addProtocol(engagement.invoiceUrl);
                    const newWindow = window.open(url, '_blank')
                    if (newWindow) newWindow.opener = null
                }});
            }
            if(proposal.contentReady) {
                items.push({label: 'View article', onClick: () => { 
                    setShowPreviewModal(true);
                }});
            }
            if( ! proposal.doNotExpire) {
                items.push({label: 'Do not expire', onClick: () => setDoNotExpire()});
            }
            items.push({label: 'Abort', onClick: () => setShowAbortModal(true)});
        }
        return items;
    }

    return (
            <Layout pagetitle='Proposal details'>
                
                <PageTitle id="proposal-detail-id" title="Proposal"/>
                
                {proposal ?
                    <>
                    <div>
                        {proposal.doNotExpire ?
                            <div className="float-left mt-1 mr-1">
                                <img src={DoNotExpire} alt="Do not expire" width={22} height={22} className="" />
                            </div>
                            :
                            <div className="float-left mt-1 mr-1">
                                <img src={Timer} alt="Expires" width={22} height={22} className="" />
                            </div>
                        }
                        <NiceDate isostring={proposal.dateCreated}/>
                    </div>
                    <DotMenu items={createMenuItems()} classNames="float-left mt-6"/>
                    <TrafficLights proposal={proposal} updateHandler={setProposal} interactive={true}/>
                    {proposal.blogLive ?
                        <div className="card grid grid-cols-3 m-4">
                            <span className='text-center font-extrabold text-lg col-span-2'>{proposal.liveLinkTitle}</span>
                            <span className='truncate'>
                                <Link to={addProtocol(proposal.liveLinkUrl)} className='truncate' target='_blank' rel='nofollow'>
                                    {proposal.liveLinkUrl}
                                </Link>
                            </span>
                        </div>
                    : null}
                    <div className="flex">
                            {supplier ?
                                <div className="flex-initial w-1/2" id="supplierPanel">
                                    <SupplierCard supplier={supplier} latest={null == currentSupplier} editable={false} linkable={true} />
                                    <div className="card list-card">
                                        <div className="grid grid-cols-2" id="metadata">
                                            <span>Created</span> <NiceDate isostring={proposal.dateCreated}/>
                                            <span>Sent to supplier</span> <NiceDate isostring={proposal.dateSentToSupplier}/>
                                            <span>Accepted by supplier</span> <NiceDate isostring={proposal.dateAcceptedBySupplier}/>
                                            <span>Invoice received</span> <NiceDate isostring={proposal.dateInvoiceReceived}/>
                                            <span>Invoice paid</span> <NiceDate isostring={proposal.dateInvoicePaid}/>
                                            <span>Blog live</span> <NiceDate isostring={proposal.dateBlogLive}/>
                                            <span>Validated</span> <NiceDate isostring={proposal.dateValidated}/> 
                                        </div>
                                    </div>
                                </div>
                            : 
                                null
                            }
                            <div className="flex-1">
                                {demands.map( (ld,index) => 
                                    <DemandCard 
                                        demand={ld} 
                                        key={ld.name} 
                                        id={"demandcard-"+index} 
                                        editable={true} 
                                        editHandler={(demand) => editDemand(demand)}
                                        fullfilable={false} 
                                        deletable={false}/>)}
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
                    }
                    {showInvoiceDownloadModal ?
                        <Modal title={"Download invoice"} dismissHandler={() => setShowInvoiceDownloadModal(false)} width={"w-1/3"}>
                            {engagement ?
                                <>
                                <LabeledText label="Filename" text={engagement.invoiceFileName} textClasses={"text-2xl"}/>
                                <LabeledText label="File type" text={engagement.invoiceFileContentType} />
                                <div className="flex justify-end pt-4">
                                    <Link to={"/.rest/engagements/downloadInvoice?proposalId="+engagement.proposalId} target='_blank' rel='nofollow'>
                                        Download
                                    </Link>
                                </div>
                                </>
                            : 
                                null
                            }
                            
                            {invoiceError ?
                                <>
                                <p className='text-2xl font-dark py-2'>Error</p>
                                <p className='font-dark pb-2'>{invoiceError}</p>
                                </>
                            : 
                                null
                            }
                            
                        </Modal>
                    : 
                        null
                    }
                    {showPreviewModal ?
                        <Modal title="Article" dismissHandler={() => { setShowPreviewModal(false) }} width="w-2/3">
                            <iframe src={"/.rest/proposalsupport/getArticleFormatted?proposalId=" + proposalid} width="100%" height={480} />
                        </Modal>
                        :
                        null
                    }
                    {showEditDemandModal ?
                        <Modal title="Edit demand" dismissHandler={() => setShowEditDemandModal(false)}>
                            <AddOrEditDemand demand={demandBeingEdited} successHandler={() => setShowEditDemandModal(false)} />
                        </Modal>
                    :
                        null
                    }
                    </>
                :
                    <Loading error={error}/>
                }
            </Layout>
    );
}