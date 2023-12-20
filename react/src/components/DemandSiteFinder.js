import React, {useState, useEffect} from 'react'
import { useSession } from "next-auth/react";
import DemandSiteSearchResult from './DemandSite';
import Modal from './atoms/Modal';
import TextInput from './atoms/TextInput';
import { ClickHandlerButton } from './atoms/Button';
import Image from 'next/image';
import Icon from '@/pages/demand/arrow-bend-up-left.svg';

export default function DemandSiteFinder({searchTerm, demandsiteSelectedHandler}) {
    const { data: session } = useSession();
    const [showModal, setShowModal] = useState(false)
    const [searchResults, setSearchResults] = useState([])
    const [newDemandsiteName, setNewDemandsiteName] = useState()
    const [newDemandsiteWebsite, setNewDemandsiteWebsite] = useState()
    
    useEffect( () => {
        if(searchTerm && searchTerm.length > 2) {
            const searchUrl = "/.rest/demandsites/search/findByEmailContainsIgnoreCaseOrNameContainsIgnoreCase?name="+searchTerm+"&email="+searchTerm
            fetch(searchUrl)
                .then(resp => resp.json())
                .then(data => setSearchResults(data))
    ***REMOVED***
        else {
            setSearchResults([])
    ***REMOVED***
***REMOVED***, [searchTerm]);

    function createNewDemandSite(name, website) {
        setShowModal(false)
        const demandsiteUrl = "/.rest/demandsites"
        const demandsite = {}
        demandsite.name = name
        demandsite.url = website
        demandsite.createdBy = session.user.email

        fetch(demandsiteUrl, {
            method: 'POST',
            headers: {'Content-Type':'application/json'},
            body: JSON.stringify(demandsite)
    ***REMOVED***)
        .then( (resp) => {
            if(resp.ok) {
                demandsiteSelectedHandler(demandsite)
        ***REMOVED***
            else {
                console.log("Created failed: "+JSON.stringify(resp));
        ***REMOVED***
    ***REMOVED***);
***REMOVED***

    return (
        <>
        <div>
            <div className="grid place-content-end">
                <ClickHandlerButton label="Create new site" clickHandler={()=>setShowModal(true)} />
                {showModal ?
                    <Modal dismissHandler={()=>setShowModal(false)} title="Create new demand site" width="w-1/3">
                        <TextInput changeHandler={setNewDemandsiteName} label="Name"/>
                        <TextInput changeHandler={setNewDemandsiteWebsite} label="Website"/>
                        <div className="pt-4">
                            <ClickHandlerButton label="Submit" clickHandler={()=>createNewDemandSite(newDemandsiteName, newDemandsiteWebsite)}/>
                        </div>
                    </Modal>
                : null}
            </div>
            {searchResults && searchResults.length > 0 ?
                searchResults.map( (sr,index) => 
                    <DemandSiteSearchResult demandSite={sr} key={index} selectedHandler={demandsiteSelectedHandler}/>
                )
            :
            <div className="">
                <Image src={Icon} alt="arrow up and left" /> 
                <p className="text-slate-500 text-7xl">Specify a name</p>
                <p className="text-slate-500 text-4xl pt-4">3 characters min.</p>
            </div>
        ***REMOVED***
        </div>
        </>
    );    
}