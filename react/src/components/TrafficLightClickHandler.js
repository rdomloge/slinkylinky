
import { useSession } from "next-auth/react";
import React, {useState} from 'react'

import Modal from "./atoms/Modal";
import TextInput from "./atoms/TextInput";
import { ClickHandlerButton } from "./atoms/Button";

export default function TrafficLightClickHandler({children, proposal, updateHandler, propertyName, propertyDate}) {
    const { data: session } = useSession();
    const [showModal, setShowModal] = useState(false)
    const [postTitle, setPostTitle] = useState("")
    const [postUrl, setPostUrl] = useState("")

    function parseId(entity) {
        const url = entity._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
***REMOVED***

    function clickHandler() {
        if(propertyName === "blogLive")
            if(proposal.blogLive) {
                proposal.liveLinkUrl = null
                proposal.liveLinkTitle = null
                toggle()
        ***REMOVED***
            else {
                setShowModal(true)
        ***REMOVED***
        else
            toggle();
***REMOVED***

    function setCapturedValue(url, title) {
        proposal.liveLinkUrl = url;
        proposal.liveLinkTitle = title;
        if("" === url || "" === title) 
            console.log("Blank URL or title");
        else
            toggle();
***REMOVED***
    
    function toggle() {
        const proposalUrl = "/.rest/proposals/"+parseId(proposal);
        const postData = {}
        postData.updatedBy = session.user.email
        postData[propertyName] = ! proposal[propertyName]
        if(null != propertyDate) {
            postData[propertyDate] = postData[propertyName] ? new Date().toISOString() : null
    ***REMOVED***
        if("blogLive" === propertyName) {
            postData.liveLinkUrl = proposal.liveLinkUrl
            postData.liveLinkTitle = proposal.liveLinkTitle
    ***REMOVED***
        const bodyJson = JSON.stringify(postData)

        fetch(proposalUrl, {
            method: 'PATCH',
            headers: {'Content-Type':'application/json'},
            body: bodyJson
    ***REMOVED***).then( (resp) => {
            proposal[propertyName] = ! proposal[propertyName]
            if(null != propertyDate) {
                proposal[propertyDate] = proposal[propertyName] ? new Date().toISOString() : null
        ***REMOVED***
            updateHandler({...proposal***REMOVED***
    ***REMOVED***).catch(error => console.error("Oh noes! An error: "+error));
***REMOVED***

    return (
        <div className="inline-block cursor-pointer">
        <div onClick={() => clickHandler()}>
            {children}
        </div>
        <div>
            {showModal ?
                <Modal dismissHandler={()=>setShowModal(false)} title="Post details" width="w-1/3">
                    <TextInput label="Post titlë" changeHandler={(e)=>setPostTitle(e)}/>
                    <TextInput label="Live link URL" changeHandler={(e)=>setPostUrl(e)}/>
                    <div className="pt-4">
                        <ClickHandlerButton label="Submit" 
                            clickHandler={()=> {
                                setCapturedValue(postUrl,postTitle);
                                setShowModal(false);
                         ***REMOVED***}/>
                    </div>
                </Modal>
                :
                null
        ***REMOVED***
        </div>
        </div>
    );
}