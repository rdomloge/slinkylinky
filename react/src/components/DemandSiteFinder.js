import React, {useState, useEffect} from 'react'
import { useSession } from "next-auth/react";
import DemandSiteSearchResult from './DemandSite';
import Modal from './atoms/Modal';
import TextInput from './atoms/TextInput';
import { ClickHandlerButton } from './atoms/Button';

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
        }
        else {
            console.log("Search term too short: "+searchTerm)
            setSearchResults([])
        }
    }, [searchTerm]);

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
        })
        .then( (resp) => {
            if(resp.ok) {
                demandsiteSelectedHandler(demandsite)
            }
            else {
                console.log("Created failed: "+JSON.stringify(resp));
            }
        });
    }

    return (
        <>
        <p className="text-end">Demand sites</p>
        <div className="float-right">
            <div className="grid place-content-end">
                <ClickHandlerButton labelText="Create new site" clickHandler={()=>setShowModal(true)} />
                {showModal ?
                    <Modal dismissHandler={()=>setShowModal(false)} title="Create new demand site">
                        <TextInput changeHandler={setNewDemandsiteName} label="Name"/>
                        <TextInput changeHandler={setNewDemandsiteWebsite} label="Website"/>
                        <div className="pt-4">
                            <ClickHandlerButton labelText="Submit" clickHandler={()=>createNewDemandSite(newDemandsiteName, newDemandsiteWebsite)}/>
                        </div>
                    </Modal>
                : null}
            </div>
            {searchResults && searchResults.length > 0 ?
                searchResults.map( (sr,index) => 
                    <DemandSiteSearchResult demandSite={sr} key={index} selectedHandler={demandsiteSelectedHandler}/>
                )
            : <p className="text-end">Search term too short or nothing found</p>}
        </div>
        </>
    );    
}