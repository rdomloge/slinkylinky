import React, {useState, useEffect} from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import Layout from '@/components/layout/Layout'
import SupplierCard from '@/components/SupplierCard'
import DemandCard from '@/components/DemandCard'
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
import Timer from "@/assets/timer.svg";
import DoNotExpire from "@/assets/expired.svg";
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
                        if(p.supplierSnapshot) {
                            // Fast path: use the JSON snapshot stored at proposal creation time
                            setSupplier(JSON.parse(p.supplierSnapshot));
                        } else {
                            // Legacy fallback for proposals created before snapshots were introduced
                            const url = "/.rest/supplierSupport/getVersion?supplierId="+p.paidLinks[0].supplier.id
                                        +"&version="+p.supplierSnapshotVersion
                            fetchWithAuth(url, {headers: {'Cache-Control': 'no-cache'}})
                                .then( (res) => res.ok ? res.json() : null)
                                .then( (s) => setSupplier(s ?? p.paidLinks[0].supplier))
                                .catch( () => setSupplier(p.paidLinks[0].supplier));
                        }
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
            <Layout pagetitle='Proposal details'
                headerTitle="Proposal"
                headerActions={proposal ? <DotMenu items={createMenuItems()} classNames="shrink-0"/> : null}
            >

                {proposal ?
                    <>
                    {/* Date line */}
                    <div className="flex items-center gap-1.5 px-6 pb-3">
                        <img src={proposal.doNotExpire ? DoNotExpire : Timer} alt={proposal.doNotExpire ? "Does not expire" : "Expires"} width={16} height={16} className="opacity-50"/>
                        <span className="text-sm text-slate-500"><NiceDate isostring={proposal.dateCreated}/></span>
                    </div>

                    {/* Traffic lights */}
                    <div className="px-6 pb-4">
                        <TrafficLights proposal={proposal} updateHandler={setProposal} interactive={true}/>
                    </div>

                    {/* Live link card */}
                    {proposal.blogLive &&
                        <div className="card mx-6 mb-4">
                            <div className="flex items-start justify-between gap-4">
                                <div className="min-w-0">
                                    <span className="inline-flex items-center gap-1.5 bg-green-50 text-green-700 text-xs font-semibold px-2.5 py-1 rounded-full border border-green-200 mb-2">
                                        <div className="w-1.5 h-1.5 rounded-full bg-green-500"/>
                                        Live
                                    </span>
                                    <p className="text-base font-semibold text-slate-900">{proposal.liveLinkTitle}</p>
                                </div>
                                <Link to={addProtocol(proposal.liveLinkUrl)} target='_blank' rel='nofollow'
                                    className="shrink-0 inline-flex items-center gap-1.5 text-sm text-indigo-600 hover:text-indigo-800 hover:underline">
                                    <span className="truncate max-w-xs">{proposal.liveLinkUrl}</span>
                                    <svg xmlns="http://www.w3.org/2000/svg" className="w-3.5 h-3.5 opacity-70" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                                        <path strokeLinecap="round" strokeLinejoin="round" d="M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" />
                                    </svg>
                                </Link>
                            </div>
                        </div>
                    }
                    <div className="flex">
                            {supplier ?
                                <div className="flex-initial w-1/2" id="supplierPanel">
                                    <SupplierCard supplier={supplier} latest={null == currentSupplier} editable={false} linkable={true} />
                                    <div className="card list-card" id="metadata">
                                        <p className="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-3">Timeline</p>
                                        <div className="space-y-1">
                                            {[
                                                { label: 'Created',              date: proposal.dateCreated },
                                                { label: 'Sent to supplier',     date: proposal.dateSentToSupplier },
                                                { label: 'Accepted by supplier', date: proposal.dateAcceptedBySupplier },
                                                { label: 'Invoice received',     date: proposal.dateInvoiceReceived },
                                                { label: 'Invoice paid',         date: proposal.dateInvoicePaid },
                                                { label: 'Blog live',            date: proposal.dateBlogLive },
                                                { label: 'Validated',            date: proposal.dateValidated },
                                            ].map(({ label, date }) => (
                                                <div key={label} className="flex items-center justify-between py-1.5 border-b border-slate-50 last:border-0">
                                                    <div className="flex items-center gap-2">
                                                        <div className={`w-2 h-2 rounded-full shrink-0 ${date ? 'bg-green-500' : 'bg-gray-200'}`}/>
                                                        <span className={`text-sm ${date ? 'text-slate-700' : 'text-slate-400'}`}>{label}</span>
                                                    </div>
                                                    <span className={`text-sm ${date ? 'text-slate-900 font-medium' : 'text-slate-300'}`}>
                                                        {date ? new Date(date).toDateString() : '—'}
                                                    </span>
                                                </div>
                                            ))}
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