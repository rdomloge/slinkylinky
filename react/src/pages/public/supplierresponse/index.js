import { useRouter } from "next/router";
import { useEffect, useState } from "react";

import { StyledButton } from "@/components/atoms/Button";
import Modal from "@/components/atoms/Modal";
import TextInput from "@/components/atoms/TextInput";
import LayoutPublic from "@/components/layout/LayoutPublic";
import PageTitle from "@/components/pagetitle";
import Loading from "@/components/Loading";
import Jumbotron from "@/components/Jumbotron";
import StyledCheckbox from "@/components/atoms/Checkbox";

export default function SupplierResponse() {

    const router = useRouter()

    const [error, setError] = useState(null)
    const [uploadError, setUploadError] = useState(null)
    const [engagement, setEngagement] = useState()
    const [showAcceptModal, setShowAcceptModal] = useState()
    const [showDeclineModal, setShowDeclineModal] = useState()
    const [showPreviewModal, setShowPreviewModal] = useState(false)
    const [blogTitle, setBlogTitle] = useState("")
    const [blogUrl, setBlogUrl] = useState("")
    const [noInvoice, setNoInvoice] = useState(false)

    const [filename, setFilename] = useState(null);



    useEffect(() => {
        if (router.isReady) {
            const id = router.query.id;
            const url = "/.rest/engagements/search/findByGuid?guid=" + id;
            fetch(url)
                .then((res) => res.json())
                .then((e) => {
                    setEngagement(e);
            ***REMOVED***)
                .catch((err) => setError(err));
    ***REMOVED***
***REMOVED***, [router.isReady, router.query.id])

    const uploadToClient = (event) => {
        if (event.target.files && event.target.files[0]) {
            const i = event.target.files[0];
            setFilename(i);
    ***REMOVED***
***REMOVED***;

    const uploadToServer = (event) => {
        const body = new FormData();
        body.append("file", filename);
        const id = router.query.id;
        return fetch("/.rest/engagements/uploadInvoice?guid="+id, {
            method: "POST", 
            body: body
    ***REMOVED***)
***REMOVED***;

    const sendBlogDetails = (event) => {
        const id = router.query.id;
        const response = fetch("/.rest/engagements/updateblogdetails?guid="+id, {
            method: "PATCH", 
            headers: {
                'Content-Type': 'application/json'
        ***REMOVED***,
            body: JSON.stringify({
                blogTitle: blogTitle,
                blogUrl: blogUrl
        ***REMOVED***)})
            .then((res) => {
                if(res.ok) {
                    window.location.reload();
            ***REMOVED***
        ***REMOVED***)
            .catch((err) => console.error(err))
***REMOVED***

    function noInvoiceCheckboxChanged(value) {
        console.log("no invoice checkbox changed: "+value.target.checked);
***REMOVED***

    function submit() {
        if(noInvoice) {
            sendBlogDetails();
            setShowAcceptModal(false);
    ***REMOVED*** 
        else {
            uploadToServer()
            .then((res) => {
                if(res.ok) {
                    sendBlogDetails();
                    setShowAcceptModal(false);
            ***REMOVED***
        ***REMOVED***)
            .catch((err) => {
                console.error(err);
        ***REMOVED***)
    ***REMOVED***
***REMOVED***

    return (
        <>
            {engagement ?
                <LayoutPublic>
                    {engagement.status === 'ACCEPTED' ?
                        <Jumbotron header={"Many thanks for submitting your response."} message={"We'll be in touch soon!"}/>
                    :
                    <div className="flex justify-center items-center">
                        <div className="card p-8 m-8 w-2/3">
                            <PageTitle title="Supplier response" />
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
                                    <StyledButton type="risky" label="Decline" submitHandler={() => { setShowDeclineModal(true) }} />
                                </div>
                                <div className="flex-1 flex justify-end">
                                    <StyledButton type="tertiary" label="Review article" submitHandler={() => { setShowPreviewModal(true) }} />
                                    <StyledButton type="secondary" label="Accept" submitHandler={() => { setShowAcceptModal(true) }} />
                                </div>
                            </section>

                            {showAcceptModal ?
                                <Modal title="Accept offer" dismissHandler={() => { setShowAcceptModal(false) }} width="w-1/2">
                                    <p className="text-2xl font-bold">By accepting this offer, you agree to the terms and conditions of the contract.</p>
                                    <TextInput label="Article title" changeHandler={(e) => { setBlogTitle(e) }} />
                                    <TextInput label="URL to article" changeHandler={(e) => { setBlogUrl(e) }} />
                                    <div className="block p-4">
                                        <input type="file" onChange={uploadToClient} />
                                    </div>
                                    {noInvoice ? 
                                        <p className="pb-4 text-red-500 font-bold">This may slow down payment</p>
                                    :
                                        <p className="pb-4">Invoice will be paid within 30 days</p>
                                ***REMOVED***
                                    <StyledCheckbox label="No invoice" onChangeHandler={(value)=>setNoInvoice(value.target.checked)}/>
                                    <div className="inline-block flex">
                                        <div className="flex-1 flex justify-end">
                                            <StyledButton type="secondary" label="Accept" submitHandler={submit} 
                                                enabled={blogTitle.length > 0 && blogUrl.length > 0 && (filename || noInvoice)} />
                                        </div>
                                    </div>
                                </Modal>
                                :
                                null
                        ***REMOVED***
                            {showDeclineModal ?
                                <Modal title="Decline offer" dismissHandler={() => { setShowDeclineModal(false) }} width="w-1/2">
                                    <p>By declining this offer, you will not be able to accept it later.</p>
                                    <TextInput label="(optional )Reason for declining" changeHandler={() => { }} />
                                    <StyledButton type="risky" label="Decline" submitHandler={() => { }} />
                                </Modal>
                                :
                                null
                        ***REMOVED***
                            {showPreviewModal ?
                                <Modal title="Article" dismissHandler={() => { setShowPreviewModal(false) }} width="w-2/3">
                                    <iframe src={"/.rest/proposalsupport/getArticleFormatted?proposalId=" + engagement.proposalId} width="100%" height={480} />
                                </Modal>
                                :
                                null
                        ***REMOVED***
                            {uploadError ?
                                <Modal title="Upload error" dismissHandler={() => { setUploadError(null) }} width="w-1/2">
                                    <p className="text-red-500">Invoice upload failed. Perhaps try a smaller file size?</p>
                                </Modal>
                                :
                                null
                        ***REMOVED***
                        </div>
                    </div>
            ***REMOVED***
                </LayoutPublic>
                :
                <>
                    {error ?
                        <p className="text-8xl font-black p-8">404 - page not found</p>
                        :
                        <Loading />
                ***REMOVED***
                </>
        ***REMOVED***
        </>
    );
}