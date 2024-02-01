import React, {useState} from 'react'
import { useSession } from "next-auth/react";
import TextInput from '@/components/atoms/TextInput';
import NumberInput from '@/components/atoms/NumberInput';
import DemandSiteFinder from './DemandSiteFinder';
import Loading from './Loading';
import CategoriesCard from './categoriescard';
import { EditDemandSubmitButton } from './atoms/Button';
import { fixForPosting } from './CategoryUtil'; 

export default function AddOrEditDemand({demand, updateNudge}) {

    const { data: session } = useSession();
    const [searchTerm, setSearchTerm] = useState()
    const [demandsite, setDemandsite] = useState()
    const [editMode] = useState(demand.id ? true : false)
        

    function submitHandler() {
        
        console.log("Demand: "+JSON.stringify(demand))
        const demandUrl = "/.rest/demands"
        const requestedDate = new Date(demand.requested)
        demand.requested = requestedDate.toISOString()

        fixForPosting(demand)

        if(demand.id) {

            delete demand._links
            demand.updatedBy = session.user.email

            fetch(demandUrl+"/"+demand.id, {
                method: 'PATCH',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(demand)
            }).then(resp => {
                if(resp.ok) {
                    location.href = "/demand";
                }
                else {
                    console.log("Patch failed: "+JSON.stringify(resp))
                }
            })
        }
        else {
            demand.createdBy = session.user.email
            fetch(demandUrl, {
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
                    console.log("Created failed: "+JSON.stringify(resp));
                }
            });
        }
    }

    function demandsiteSelectedHandler(demandsite) {
        setDemandsite(demandsite)
        setSearchTerm(demandsite.name)
        demand.name = demandsite.name
        demand.categories = demandsite.categories.filter(c => c.disabled == false)
        demand.url = demandsite.url
        updateNudge(demand)
    }

    function categoryChangeHandler(categories) {
        console.log("New selected categories: "+JSON.stringify(categories))
        const categoryHrefs = categories.map(c => c.value)
        demand.categories = categoryHrefs
    }

    return (
        <>
        {demand ?
        <div className="flex">
            <div className="flex-1">
                <div className="content-center mb-4">
                    <EditDemandSubmitButton submitHandler={submitHandler} demand={demand} demandsite={demandsite}/>
                </div>
                <div>
                <form className="w-full max-w-lg card">
                    <div className="flex flex-wrap -mx-3 mb-6">
                        <div className="w-full md:w-1/2 px-3 mb-6 md:mb-0">
                            {demandsite ?
                                <p className="h-full flex items-center text-xl">{demandsite.name}</p>
                            :
                                <TextInput label="name" disabled={editMode || demandsite} changeHandler={(e)=>{
                                    demand.name=e
                                    setSearchTerm(e)
                                }} initialValue={demand.name}/>
                            }
                        </div>
                        <div className="w-full md:w-1/2 px-3">
                            <TextInput label="Anchor text" changeHandler={(e)=>demand.anchorText=e} initialValue={demand.anchorText} disabled={!demand.id && !demandsite}/>
                        </div>
                    </div>
                    <div className="flex flex-wrap -mx-3 mb-6">
                        <div className="w-full px-3">
                            <TextInput label="URL" changeHandler={(e)=>demand.url=e} initialValue={demand.url} disabled={!demand.id && !demandsite}/>
                        </div>
                    </div>
                    <div className="flex flex-wrap -mx-3 mb-2">
                        <div className="w-full md:w-1/3 px-3 mb-6 md:mb-0">
                            <NumberInput label="DA needed" changeHandler={(e)=>demand.daNeeded=e} initialValue={demand.daNeeded}  disabled={!demand.id && !demandsite}/>
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
                    <p></p>
                :
                <DemandSiteFinder searchTerm={searchTerm} demandsiteSelectedHandler={demandsiteSelectedHandler}/> }
            </div>
        </div>
        : <Loading/> }
        </>
    );
}