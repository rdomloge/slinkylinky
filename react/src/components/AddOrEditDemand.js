import React, {useState} from 'react'
import CategorySelector from "@/components/CategorySelector";
import { useSession } from "next-auth/react";
import TextInput from '@/components/atoms/TextInput';
import NumberInput from '@/components/atoms/NumberInput';
import DemandSiteFinder from './DemandSiteFinder';
import Loading from './Loading';
import CategoriesCard from './categoriescard';

export default function AddOrEditDemand({demand, updateNudge}) {

    const { data: session } = useSession();
    const [searchTerm, setSearchTerm] = useState()
    const [demandsite, setDemandsite] = useState()
    const [demandName, setDemandName] = useState("")
        

    function submitHandler() {
        
        console.log("Demand: "+JSON.stringify(demand))
        const demandUrl = "/.rest/demands"
        const requestedDate = new Date(demand.requested)
        demand.requested = requestedDate.toISOString()

        if(demand.categories && demand.categories.length > 0 && demand.categories[0].name) {
            demand.categories = demand.categories.map((c)=>"/.rest/categories/" + c.id)
    ***REMOVED***

        if(demand.id) {
            fetch(demandUrl+"/"+demand.id, {
                method: 'PATCH',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(demand)
        ***REMOVED***).then(resp => {
                if(resp.ok) {
                    location.href = "/demand";
            ***REMOVED***
                else {
                    console.log("Patch failed: "+JSON.stringify(resp))
            ***REMOVED***
        ***REMOVED***)
    ***REMOVED***
        else {
            demand.createdBy = session.user.email
            fetch(demandUrl, {
                method: 'POST',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(demand)
        ***REMOVED***)
            .then( (resp) => {
                if(resp.ok) {
                    const locationUrl = resp.headers.get('Location')
                    console.log("New demand created at "+locationUrl)
                    location.href = "/demand";
            ***REMOVED***
                else {
                    console.log("Created failed: "+JSON.stringify(resp));
            ***REMOVED***
        ***REMOVED***);
    ***REMOVED***
***REMOVED***

    function demandsiteSelectedHandler(demandsite) {
        setDemandsite(demandsite)
        setSearchTerm(demandsite.name)
        demand.name = demandsite.name
        demand.categories = demandsite.categories
        demand.url = demandsite.url
        updateNudge(demand)
***REMOVED***

    function categoryChangeHandler(categories) {
        console.log("New selected categories: "+JSON.stringify(categories))
        const categoryHrefs = categories.map(c => c.value)
        demand.categories = categoryHrefs
***REMOVED***

    return (
        <>
        {demand ?
        <div className="flex">
            <div className="flex-1">
                <div className="content-center mb-4">
                    <button id="createnew" onClick={submitHandler} disabled={!demandsite}
                        className={"text-white font-bold py-2 p-4 border border-blue-700 rounded "+(demandsite?"bg-blue-500 hover:bg-blue-700":"bg-grey-500 hover:bg-grey-700")}>
                        Submit
                    </button>
                </div>
                <div>
                <form className="w-full max-w-lg card">
                    <div className="flex flex-wrap -mx-3 mb-6">
                        <div className="w-full md:w-1/2 px-3 mb-6 md:mb-0">
                            <TextInput label="name" stateValue={demandName} disabled={demandsite} changeHandler={(e)=>{
                                demand.name=e
                                setSearchTerm(e)
                        ***REMOVED***} initialValue={demand.name}/>
                        </div>
                        <div className="w-full md:w-1/2 px-3">
                            <TextInput label="Anchor text" changeHandler={(e)=>demand.anchorText=e} initialValue={demand.anchorText}/>
                        </div>
                    </div>
                    <div className="flex flex-wrap -mx-3 mb-6">
                        <div className="w-full px-3">
                            <TextInput label="URL" changeHandler={(e)=>demand.url=e} initialValue={demand.url}/>
                        </div>
                    </div>
                    <div className="flex flex-wrap -mx-3 mb-2">
                        <div className="w-full md:w-1/4 px-3 mb-6 md:mb-0">
                            <NumberInput label="DA needed" changeHandler={(e)=>demand.daNeeded=e} initialValue={demand.daNeeded} />
                        </div>
                        <div className="w-full md:w-3/4 px-3 mb-6 md:mb-0">
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
                            <input id="grid-requested" type="date" placeholder="" onChange={(e)=>demand.requested=e.target.value} value={demand.created}
                                className="appearance-none block w-full border-b border-teal-500 text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"/>
                            </div>
                        </div>
                    </div>
                    </form>
                </div>
            </div>
            <div className="flex-1 p-4">
                {demand.id ?
                    <p>Edit mode</p>
                :
                <DemandSiteFinder searchTerm={searchTerm} demandsiteSelectedHandler={demandsiteSelectedHandler}/> }
            </div>
        </div>
        : <Loading/> }
        </>
    );
}