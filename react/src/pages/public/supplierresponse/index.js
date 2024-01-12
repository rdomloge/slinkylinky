import { useRouter } from "next/router";
import { useEffect, useState } from "react";

import { StyledButton } from "@/components/atoms/Button";
import Modal from "@/components/atoms/Modal";
import TextInput from "@/components/atoms/TextInput";
import LayoutPublic from "@/components/layout/LayoutPublic";
import PageTitle from "@/components/pagetitle";
import Loading from "@/components/Loading";

export default function SupplierResponse() {

    const router = useRouter()
    const [error, setError] = useState(null)
    const [engagement, setEngagement] = useState()
    const [showAcceptModal, setShowAcceptModal] = useState()
    const [showDeclineModal, setShowDeclineModal] = useState()
    const [invoiceUploaded, setInvoiceUploaded] = useState(false)
    const [showPreviewModal, setShowPreviewModal] = useState(false)
    const [blogTitle, setBlogTitle] = useState("")
    const [blogUrl, setBlogUrl] = useState("")
    

    useEffect(() => {
        if(router.isReady) {
            const id = router.query.id;
            const url = "/.rest/engagements/search/findByGuid?guid="+id;
            fetch(url)
                .then( (res) => res.json())
                .then( (e) => {
                    setEngagement(e);
            ***REMOVED***)
                .catch( (err) => setError(err));
    ***REMOVED***
***REMOVED***, [router.isReady, router.query.id])

    return (
            <>
            {engagement ?
                <LayoutPublic>
                <div className="flex justify-center items-center">
                <div className="card p-8 m-8 w-2/3">
                    <PageTitle title="Supplier response"/>
                    <h2 className="text-2xl font-bold py-4">{engagement.supplierName}</h2>
                    <p className="text-lg font-bold">Please indicate your response to our offer below.</p>

                    <p className="text-3xl p-6">
                        <b className="text-red-500 font-bold text-4xl">{engagement.supplierWeWriteFeeCurrency}{engagement.supplierWeWriteFee} </b> 
                        for hosting the article we sent to {engagement.supplierEmail} on {new Date(engagement.supplierEmailSent).toDateString()} 
                    </p>
                    <p>Offer ID: {engagement.proposalId}</p>
                    <p>
                        If you intend to accept, but the article is not yet hosted or the invoice is not yet issued, please close the browser tab and come click the link again
                        in the future.
                    </p>
                    
                    <section className="mt-6 border-t border-gray-200 flex">
                        <div className="flex-initial">
                            <StyledButton type="risky" label="Decline" submitHandler={()=>{setShowDeclineModal(true)}}/>
                        </div>
                        <div className="flex-1 flex justify-end">
                            <StyledButton type="tertiary" label="Review article" submitHandler={()=>{setShowPreviewModal(true)}}/>
                            <StyledButton type="secondary" label="Accept" submitHandler={()=>{setShowAcceptModal(true)}}/>
                        </div>
                    </section>
    
                    {showAcceptModal ? 
                        <Modal title="Accept offer" dismissHandler={()=>{setShowAcceptModal(false)}} width="w-1/2"> 
                            <p>By accepting this offer, you agree to the terms and conditions of the contract.</p>
                            <TextInput label="Article title" stateValue={blogTitle} changeHandler={(e)=>{setBlogTitle(e)}}/>
                            <TextInput label="URL to article" stateValue={blogUrl} changeHandler={(e)=>{setBlogUrl(e)}}/>
                            <StyledButton type="tertiary" label="Upload invoice" submitHandler={()=>{}}/>
                            <StyledButton type="primary" label="Accept" submitHandler={()=>{}} enabled={blogTitle.length > 0 && blogUrl.length > 0}/>
                        </Modal>
                    : 
                        null
                ***REMOVED***
                    {showDeclineModal ? 
                        <Modal title="Decline offer" dismissHandler={()=>{setShowDeclineModal(false)}} width="w-1/2"> 
                            <p>By declining this offer, you will not be able to accept it later.</p>
                            <TextInput label="(optional )Reason for declining" changeHandler={()=>{}}/>
                            <StyledButton type="risky" label="Decline" submitHandler={()=>{}}/>
                        </Modal>
                    : 
                        null
                ***REMOVED***
                    {showPreviewModal ?
                        <Modal title="Article" dismissHandler={()=>{setShowPreviewModal(false)}} width="w-2/3">
                            <iframe src={"/.rest/proposalsupport/getArticleFormatted?proposalId="+engagement.proposalId} width="100%" height={480}/>
                        </Modal>
                    :
                        null
                ***REMOVED***
                </div>
                </div>
                </LayoutPublic>
            :
                <>
                {error ?
                    <p className="text-8xl font-black p-8">404 - page not found</p>
                : 
                    <Loading/>
            ***REMOVED***
                </>
        ***REMOVED***
            </>
    );
}