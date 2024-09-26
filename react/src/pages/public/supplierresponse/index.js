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
import ErrorMessage, { InfoMessage } from "@/components/atoms/Messages";

export default function SupplierResponse() {

    const router = useRouter()

    const [guidError, setGuidError] = useState(null)
    const [acceptError, setAcceptError] = useState(null)
    const [engagement, setEngagement] = useState()
    const [showAcceptModal, setShowAcceptModal] = useState()
    const [showDeclineModal, setShowDeclineModal] = useState()
    const [showPreviewModal, setShowPreviewModal] = useState(false)
    const [blogTitle, setBlogTitle] = useState("")
    const [blogUrl, setBlogUrl] = useState("")
    const [invoiceUrl, setInvoiceUrl] = useState("");
    const [declineReason, setDeclineReason] = useState("")
    const [doNotContact, setDoNotContact] = useState(false)


    useEffect(() => {
        if (router.isReady) {
            const id = router.query.id;
            const url = "/.rest/engagements/search/findByGuid?guid=" + id;
            fetch(url)
                .then((res) => res.json())
                .then((e) => {
                    setEngagement(e);
                })
                .catch((err) => setGuidError(err));
        }
    }, [router.isReady, router.query.id])

    

    const handleAccept = (event) => {
        const id = router.query.id;
        const response = fetch("/.rest/engagements/accept?guid="+id, {
            method: "PATCH", 
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                blogTitle: blogTitle,
                blogUrl: blogUrl,
                invoiceUrl: invoiceUrl
            })})
            .then((res) => {
                if(res.ok) {
                    setShowAcceptModal(false);
                    window.location.reload();
                }
                else {
                    throw Error("Accept failed (duplicate live URL or invoice URL?)")   
                }
            })
            .catch((err) => {
                console.error(err)
                setAcceptError(err);
            })
    }

    function handleDecline() {
        const id = router.query.id;
        fetch("/.rest/engagements/decline?guid="+id, {
            method: "PATCH", 
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                declinedReason: declineReason,
                doNotContact: doNotContact
            })
        })
        .then((res) => {
            if(res.ok) {
                window.location.reload();
            }
        })
        .catch((err) => console.error(err))
    }


    return (
        <>
            {engagement ?
                <LayoutPublic>
                    {engagement.status === 'ACCEPTED' || engagement.status === 'DECLINED' ?
                        <Jumbotron header={"Many thanks for submitting your response."} message={engagement.status === 'DECLINED' ? "Sorry to see you go" : "We'll be in touch soon!"}/>
                    :
                    <div className="flex justify-center items-center">
                        <div className="card p-8 m-8 w-2/3">
                            <PageTitle title="Supplier response" id="supplier-response-title-id" />
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
                                    <p className="text-2xl font-bold">By accepting this offer you agree to the links being permanent do-follow links.</p>
                                    <TextInput label="Article title" changeHandler={(e) => { setBlogTitle(e) }} />
                                    <TextInput label="URL to article" changeHandler={(e) => { setBlogUrl(e) }} />
                                    <TextInput label="URL to invoice" changeHandler={(e) => { setInvoiceUrl(e) }} />
                                    
                                    <div className="inline-block flex">
                                        <div className="flex-1 flex justify-end">
                                            <StyledButton type="secondary" label="Accept" submitHandler={handleAccept} 
                                                enabled={blogTitle.length > 0 && blogUrl.length > 0 && invoiceUrl.length > 0} />
                                        </div>
                                    </div>
                                    {acceptError ? 
                                        <div className="mt-4">
                                            <ErrorMessage message={"Server error. Duplicate weblog URL or invoice URL?"} />
                                        </div>
                                    :
                                        null
                                    }
                                </Modal>
                                :
                                null
                            }
                            {showDeclineModal ?
                                <Modal title="Decline offer" dismissHandler={() => { setShowDeclineModal(false) }} width="w-1/2">
                                    <p>By declining this offer, you will not be able to accept it later.</p>
                                    <TextInput label="(optional) Reason for declining" initialValue={declineReason} changeHandler={(e) => { setDeclineReason(e) }} />
                                    <div className="inline-block flex justify-end">
                                        <StyledCheckbox label="Do not contact me again" checked={doNotContact} onChangeHandler={(e) => { setDoNotContact(e.target.checked) }} />
                                        <StyledButton type="risky" label="Decline" submitHandler={() => { handleDecline() }} />
                                    </div>
                                    {doNotContact && doNotContact === true ? 
                                        <InfoMessage message="You will receive one more email confirming that you are being removed from our system and we will not send you any future engagements" />
                                    : 
                                        null 
                                    }
                                </Modal>
                                :
                                null
                            }
                            {showPreviewModal ?
                                <Modal title="Article" dismissHandler={() => { setShowPreviewModal(false) }} width="w-2/3">
                                    <iframe src={"/.rest/proposalsupport/getArticleFormatted?proposalId=" + engagement.proposalId} width="100%" height={480} />
                                </Modal>
                                :
                                null
                            }
                        </div>
                    </div>
                }
                </LayoutPublic>
                :
                <>
                    {guidError ?
                        <p className="text-8xl font-black p-8">404 - page not found</p>
                        :
                        <Loading />
                    }
                </>
            }
        </>
    );
}