
import { useSession } from "next-auth/react";
import React, {useState} from 'react'

import Modal from "./atoms/Modal";
import TextInput from "./atoms/TextInput";
import { ClickHandlerButton } from "./atoms/Button";
import NumberInput from "./atoms/NumberInput";
import ContentCreator from "./ContentCreator";
import { fetchWithAuth } from "@/utils/fetchWithAuth";

export default function TrafficLightClickHandler({children, proposal, updateHandler, propertyName, propertyDate}) {
    const { data: session } = useSession();
    const [showModal, setShowModal] = useState(false)
    const [postTitle, setPostTitle] = useState("")
    const [postUrl, setPostUrl] = useState("")
    const [supplierCost, setSupplierCost] = useState(0)
    const [supplierDa, setSupplierDa] = useState(0)
    const [supplierCurrency, setSupplierCurrency] = useState()
    const [showContentCreator, setShowContentCreator] = useState(false)

    function parseId(entity) {
        const url = entity._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
    }

    function clickHandler() {
        if(propertyName === "blogLive")
            if(proposal.blogLive) {
                proposal.liveLinkUrl = null
                proposal.liveLinkTitle = null
                toggle()
            }
            else {
                setShowModal(true)
            }
        else if(propertyName === "contentReady") {
            if(proposal.contentReady) {
                toggle()
            }
            else {
                setShowContentCreator(true);
            }
        }
        else
            toggle();
    }

    function articleSubmitHandler(content) {
        const url = "/.rest/proposalsupport/addarticle?proposalId="+parseId(proposal);
        fetchWithAuth(url, {
            method: 'PATCH',
            headers: {'user': session.user.email, 'Content-Type':'text/plain'},
            body: content
            })
            .then( (res) => {
                if(res.ok) {
                    setShowContentCreator(false)
                    toggle()
                }
                else
                    console.log("Error: "+res.status)
            })
            
            ;
    }

    function setCapturedValue(url, title, supplierCost, supplierDa) {
        proposal.liveLinkUrl = url;
        proposal.liveLinkTitle = title;

        if(proposal.paidLinks[0].supplier.thirdParty) {
            proposal.paidLinks[0].supplier.weWriteFee = supplierCost
            proposal.paidLinks[0].supplier.weWriteFeeCurrency = supplierCurrency
            proposal.paidLinks[0].supplier.da = supplierDa
            proposal.paidLinks[0].supplier.website = stripUrlPath(url)
        }

        if("" === url || "" === title) 
            console.log("Blank URL or title");
        else
            toggle();
    }
    
    function toggle() {
        const proposalUrl = "/.rest/proposals/"+parseId(proposal);
        const postData = {}
        postData.updatedBy = session.user.email
        postData[propertyName] = ! proposal[propertyName]
        if(null != propertyDate) {
            postData[propertyDate] = postData[propertyName] ? new Date().toISOString() : null
        }
        if("blogLive" === propertyName) {
            postData.liveLinkUrl = proposal.liveLinkUrl
            postData.liveLinkTitle = proposal.liveLinkTitle
        }
        if("contentReady" === propertyName) {
            if(postData.contentReady) {
                postData.article = proposal.article
            }
            else {
                postData.article = null
            }
        }
        const bodyJson = JSON.stringify(postData)

        fetchWithAuth(proposalUrl, {
            method: 'PATCH',
            headers: {'Content-Type':'application/json'},
            body: bodyJson
        }).then( (resp) => {
            if(resp.ok) {
                proposal[propertyName] = ! proposal[propertyName]
                if(null != propertyDate) {
                    proposal[propertyDate] = proposal[propertyName] ? new Date().toISOString() : null
                }

                if("blogLive" === propertyName) {
                    if(proposal.paidLinks[0].supplier.thirdParty) {
                        const supplierUrl = "/.rest/suppliers/"+proposal.paidLinks[0].supplier.id;
                        fetchWithAuth(supplierUrl, {
                            method: 'PATCH',
                            headers: {'Content-Type':'application/json'},
                            body: JSON.stringify(create3rdPartySupplierPatchData())
                        })
                        .catch(error => console.error("Oh noes! An error: "+error));
                    }
                }
                updateHandler({...proposal}); // force a re-render, since we don't need to update the supplier
            }
        }).catch(error => console.error("Oh noes! An error: "+error));
    }

    function stripUrlPath(url) {
        if( ! url.startsWith("http")) {
            url = "https://"+url
        }
        const urlObj = new URL(url)
        return urlObj.origin
    }

    function create3rdPartySupplierPatchData() {
        const clearingData = proposal[propertyDate] === null; // clear the supplier data if the post is no longer live
        if(clearingData) {
            setSupplierCost(null)
            setSupplierDa(null)
            setSupplierCurrency(null)
            proposal.paidLinks[0].supplier.weWriteFee = null
            proposal.paidLinks[0].supplier.weWriteFeeCurrency = null
            proposal.paidLinks[0].supplier.da = null
            proposal.paidLinks[0].supplier.website = null
            proposal.paidLinks[0].supplier.domain = null
        }

        const supplierData = {}
        supplierData.updatedBy = session.user.email
        supplierData.weWriteFee = clearingData ? null : supplierCost
        supplierData.weWriteFeeCurrency = clearingData ? null : supplierCurrency
        supplierData.da = clearingData ? null : supplierDa
        supplierData.website = clearingData ? null : stripUrlPath(proposal.liveLinkUrl)
        return supplierData
    }

    return (
        <div className="inline-block cursor-pointer">
            <div onClick={() => clickHandler()}>
                {children}
            </div>
            {showContentCreator ?
                <ContentCreator dismissHandler={()=>setShowContentCreator(false)} submitHandler={articleSubmitHandler} proposal={proposal} />
            :
                null
            }
            <div>
                {showModal ?
                    <Modal dismissHandler={()=>setShowModal(false)} title="Post details" width="w-1/3">
                        <TextInput label="Post title" changeHandler={(e)=>setPostTitle(e)}/>
                        <TextInput label="Live link URL" changeHandler={(e)=>setPostUrl(e)}/>
                        {proposal.paidLinks[0].supplier.thirdParty ?
                            <>
                            <div className="w-1/3 inline-block p-4">
                                <TextInput label="3rd party currency" changeHandler={(e)=>setSupplierCurrency(e)}/>
                            </div>
                            <div className="w-1/3 inline-block p-4">
                                <NumberInput label="3rd party cost" changeHandler={(e)=>setSupplierCost(e)}/>
                            </div>
                            <div className="w-1/3 inline-block p-4">
                                <NumberInput label="3rd party DA" changeHandler={(e)=>setSupplierDa(e)}/>
                            </div>
                            </>
                        :
                            null
                        }
                        <div className="pt-4">
                            <ClickHandlerButton label="Submit" 
                                clickHandler={()=> {
                                    setCapturedValue(postUrl,postTitle, supplierCost, supplierDa);
                                    setShowModal(false);
                                }}/>
                        </div>
                    </Modal>
                    :
                    null
                }
            </div>
        </div>
    );
}