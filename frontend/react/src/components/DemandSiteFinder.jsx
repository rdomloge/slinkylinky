import React, {useState, useEffect} from 'react'
import { useAuth } from "@/auth/AuthProvider";
import DemandSiteSearchResult from './DemandSite';
import Modal from './atoms/Modal';
import TextInput from './atoms/TextInput';
import { ClickHandlerButton } from './atoms/Button';
import Icon from '@/assets/arrow-bend-up-left.svg';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

export default function DemandSiteFinder({searchTerm, demandsiteSelectedHandler}) {
    const { user } = useAuth();
    const [showModal, setShowModal] = useState(false)
    const [searchResults, setSearchResults] = useState([])
    const [newDemandsiteName, setNewDemandsiteName] = useState()
    const [newDemandsiteWebsite, setNewDemandsiteWebsite] = useState()
    
    useEffect( () => {
        if(searchTerm && searchTerm.length > 2) {
            const searchUrl = "/.rest/demandsites/search/findByEmailContainsIgnoreCaseOrNameContainsIgnoreCase?name="+searchTerm+"&email="+searchTerm
            fetchWithAuth(searchUrl)
                .then(resp => resp.json())
                .then(data => setSearchResults(data))
        }
        else {
            setSearchResults([])
        }
    }, [searchTerm]);

    function createNewDemandSite(name, website) {
        setShowModal(false)
        const demandsiteUrl = "/.rest/demandsites"
        const demandsite = {}
        demandsite.name = name
        demandsite.url = website
        demandsite.createdBy = user.email
        demandsite.categories = []

        fetchWithAuth(demandsiteUrl, {
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
        <div>
            <div className="grid place-content-end">
                <ClickHandlerButton label="Create new site" clickHandler={()=>setShowModal(true)} id="newDemandSite"/>
                {showModal ?
                    <Modal dismissHandler={()=>setShowModal(false)} title="Create new demand site" width="w-1/3">
                        <TextInput changeHandler={setNewDemandsiteName} label="Name" id={"newDemandSiteName"} binding={newDemandsiteName}/>
                        <TextInput changeHandler={setNewDemandsiteWebsite} label="Website" id={"newDemandSiteWebsite"} binding={newDemandsiteWebsite}/>
                        <div className="pt-4">
                            <ClickHandlerButton label="Submit" clickHandler={()=>createNewDemandSite(newDemandsiteName, newDemandsiteWebsite)} id={"createDemandSiteButton"}/>
                        </div>
                    </Modal>
                : null}
            </div>
            {searchResults && searchResults.length > 0
                ? searchResults.map((sr, index) =>
                    <DemandSiteSearchResult demandSite={sr} key={index} selectedHandler={demandsiteSelectedHandler} id={"demandSiteSearchResult-"+index}/>
                )
                : <div className="flex flex-col items-center justify-center py-12 text-center text-gray-400">
                    <img src={Icon} alt="arrow" className="w-10 h-10 opacity-20 mb-3"/>
                    <p className="text-sm font-medium">Type a site name to search</p>
                    <p className="text-xs mt-1">Minimum 3 characters</p>
                  </div>
            }
        </div>
        </>
    );    
}