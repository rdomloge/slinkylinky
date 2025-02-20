import React, {useState} from 'react'
import { useSession } from "next-auth/react";
import TextInput from '@/components/atoms/TextInput';
import NumberInput from '@/components/atoms/NumberInput';
import DemandSiteFinder from './DemandSiteFinder';
import Loading from './Loading';
import CategoriesCard from './categoriescard';
import { StyledButton } from './atoms/Button';
import { fixForPosting } from './CategoryUtil'; 
import ErrorMessage from './atoms/Messages';

export default function AddOrEditDemand({demand, successHandler}) {

    const { data: session } = useSession();
    const [searchTerm, setSearchTerm] = useState()
    const [demandsite, setDemandsite] = useState()
    const [editMode] = useState(demand.id ? true : false)

    const [demandName, setDemandName] = useState(demand.name)
    const [demandAnchorText, setDemandAnchorText] = useState(demand.anchorText)
    const [demandUrl, setDemandUrl] = useState(demand.url)
    const [demandDaNeeded, setDemandDaNeeded] = useState(demand.daNeeded)
    const [demandRequested, setDemandRequested] = useState(demand.requested)
    const [demandWordCount, setWordCount] = useState(demand.wordCount)

    const [errorMEssage, setErrorMessage] = useState()
        

    function submitHandler() {
        
        console.log("Demand: "+JSON.stringify(demand))
        const restUrl = "/.rest/demands"
        const requestedDate = new Date(demandRequested)
        demand.requested = requestedDate.toISOString()
        demand.daNeeded = demandDaNeeded
        demand.name = demandName
        demand.url = demandUrl
        demand.anchorText = demandAnchorText
        demand.wordCount = demandWordCount
        

        fixForPosting(demand)

        if(demand.id) {

            delete demand._links
            demand.updatedBy = session.user.email

            fetch(restUrl+"/"+demand.id, {
                method: 'PATCH',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(demand)
            }).then(resp => {
                if(resp.ok) {
                    if(successHandler) {
                        successHandler();
                    }
                    else {
                        location.href = "/demand";
                    }
                }
                else {
                    setErrorMessage("Create failed: "+resp.statusText)
                }
            })
        }
        else {
            demand.createdBy = session.user.email
            demand.source = 'SlinkyLinky'
            fetch(restUrl, {
                method: 'POST',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(demand)
            })
            .then( (resp) => {
                if(resp.ok) {
                    const locationUrl = resp.headers.get('Location')
                    console.log("New demand created at "+locationUrl)
                    location.href = "/demand";
                }
                else {
                    setErrorMessage("Create failed: "+resp.statusText)
                }
            });
        }
    }

    function demandsiteSelectedHandler(demandsite) {
        setDemandsite(demandsite)
        setSearchTerm(demandsite.name)
        setDemandName(demandsite.name)
        demand.categories = demandsite.categories.filter(c => c.disabled == false)
        // setDemandUrl(demandsite.url) // we don't do this because the URL should always be copy-pasted from another document
                                        // if we fill the domain in to be helpful, they forget to paste in the full URL
    }

    function categoryChangeHandler(categories) {
        console.log("New selected categories: "+JSON.stringify(categories))
        const categoryHrefs = categories.map(c => c.value)
        demand.categories = categoryHrefs
    }

    function isSubmitButtonEnabled() {
        if(demand.id) {
            return true
        }
        return demandsite ? true : false
    }

    return (
        <>
        {demand ?
            <div className="flex">
                <div className="mb-4">
                    <StyledButton submitHandler={submitHandler} enabled={isSubmitButtonEnabled()} label="Submit" type="primary"/>
                </div>
                <div className="flex-initial">
                    <div className="flex p-4">
                    
                        <ErrorMessage message={errorMEssage}/>
                        
                        <form className="max-w-lg card">
                            <div className="flex flex-wrap -mx-3 mb-6">
                                <div className="w-full md:w-1/2 px-3 mb-6 md:mb-0">
                                    {demandsite ?
                                        <p id="nameLbl" className="h-full flex items-center text-xl">{demandsite.name}</p>
                                    :
                                        <TextInput id="name" label="name" disabled={editMode || demandsite} changeHandler={(e)=>{
                                            setDemandName(e)
                                            setSearchTerm(e)
                                        }} binding={demandName}/>
                                    }
                                </div>
                                <div className="w-full md:w-1/2 px-3">
                                    <TextInput id="anchorText" label="Anchor text" changeHandler={(e)=>setDemandAnchorText(e)} binding={demandAnchorText} disabled={!demand.id && !demandsite}/>
                                </div>
                            </div>
                            <div className="flex flex-wrap -mx-3 mb-6">
                                <div className="w-2/3 px-3">
                                    <TextInput id="url" label="URL" changeHandler={(e)=>setDemandUrl(e)} binding={demandUrl} disabled={!demand.id && !demandsite}/>
                                </div>
                                <div className="w-1/3 px-3">
                                    <NumberInput id="wordCount" label="Words" changeHandler={(e)=>setWordCount(e)} binding={demandWordCount} disabled={!demand.id && !demandsite} 
                                        min={500} max={1500} step={250}/>
                                </div>
                            </div>
                            <div className="flex flex-wrap -mx-3 mb-2">
                                <div className="w-full md:w-1/3 px-3 mb-6 md:mb-0">
                                    <NumberInput id="daNeeded" label="DA needed" min={10} step={10} max={50} changeHandler={(e)=>setDemandDaNeeded(e)} binding={demandDaNeeded}  disabled={!demand.id && !demandsite}/>
                                </div>
                                <div className="w-full md:w-2/3 px-3 mb-6 md:mb-0">
                                    <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-state">
                                        Categories
                                    </label>
                                    <CategoriesCard categories={demand.categories}/>
                                </div>
                                <div className="w-full md:w-3/3 px-3 mb-6 mt-6 md:mb-0">
                                    <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-state">
                                        Requested
                                    </label>
                                    <div className="relative">
                                    <input id="requested" type="date" placeholder="" onChange={(e)=>setDemandRequested(e.target.value)} value={demand.created}
                                        className="appearance-none block w-full border-b border-teal-500 text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"/>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div className="flex-1 p-4">
                    {demand.id ?
                        <p></p>
                    :
                    <DemandSiteFinder searchTerm={searchTerm} demandsiteSelectedHandler={demandsiteSelectedHandler}/> }
                </div>
            </div>
        : 
            <Loading/> 
        }
        </>
    );
}