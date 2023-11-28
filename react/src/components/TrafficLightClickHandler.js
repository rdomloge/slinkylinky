import Link from "next/link";
import LiveLinkModal from "./LiveLinkModal";
import React, {useState, useEffect} from 'react'

export default function TrafficLightClickHandler({children, proposal, updateHandler, propertyName, propertyDate}) {
    const [showModal, setShowModal] = useState(false)

    function parseId(entity) {
        const url = entity._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
***REMOVED***

    function clickHandler() {
        if(propertyName === "blogLive")
            if(proposal.blogLive) {
                proposal.liveLinkUrl = null
                toggle()
        ***REMOVED***
            else {
                setShowModal(true)
        ***REMOVED***
        else
            toggle();
***REMOVED***

    function setCapturedValue(url) {
        proposal.liveLinkUrl = url;
        if("" === url) 
            console.log("Blank URL");
        else
            toggle();
***REMOVED***
    
    function toggle() {
        const proposalUrl = "http://localhost:8080/proposals/"+parseId(proposal);
        const postData = {}
        postData[propertyName] = ! proposal[propertyName]
        if(null != propertyDate) {
            postData[propertyDate] = postData[propertyName] ? new Date().toISOString() : null
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
        <div className="inline-block">
        <div onClick={() => clickHandler()}>
            {children}
        </div>
        <div>
            {showModal ?
                <LiveLinkModal submitHandler={(url) => setCapturedValue(url)} cancelHandler={() => {setShowModal(false)}}/>
                :
                null
        ***REMOVED***
        </div>
        </div>
    );
}