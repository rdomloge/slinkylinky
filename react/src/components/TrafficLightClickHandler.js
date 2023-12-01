import Link from "next/link";
import LiveLinkModal from "./LiveLinkModal";
import React, {useState, useEffect} from 'react'

export default function TrafficLightClickHandler({children, proposal, updateHandler, propertyName, propertyDate}) {
    const [showModal, setShowModal] = useState(false)

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
        else
            toggle();
    }

    function setCapturedValue(url, title) {
        proposal.liveLinkUrl = url;
        proposal.liveLinkTitle = title;
        if("" === url || "" === title) 
            console.log("Blank URL or title");
        else
            toggle();
    }
    
    function toggle() {
        const proposalUrl = "http://localhost:8080/proposals/"+parseId(proposal);
        const postData = {}
        postData[propertyName] = ! proposal[propertyName]
        if(null != propertyDate) {
            postData[propertyDate] = postData[propertyName] ? new Date().toISOString() : null
        }
        if("blogLive" === propertyName) {
            postData.liveLinkUrl = proposal.liveLinkUrl
            postData.liveLinkTitle = proposal.liveLinkTitle
        }
        const bodyJson = JSON.stringify(postData)

        fetch(proposalUrl, {
            method: 'PATCH',
            headers: {'Content-Type':'application/json'},
            body: bodyJson
        }).then( (resp) => {
            proposal[propertyName] = ! proposal[propertyName]
            if(null != propertyDate) {
                proposal[propertyDate] = proposal[propertyName] ? new Date().toISOString() : null
            }
            updateHandler({...proposal});
        }).catch(error => console.error("Oh noes! An error: "+error));
    }

    return (
        <div className="inline-block">
        <div onClick={() => clickHandler()}>
            {children}
        </div>
        <div>
            {showModal ?
                <LiveLinkModal submitHandler={(url,title) => setCapturedValue(url,title)} cancelHandler={() => {setShowModal(false)}}/>
                :
                null
            }
        </div>
        </div>
    );
}