import React, {useState, useEffect} from 'react'
import CategorySelector from "@/components/CategorySelector";
import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";
import { useSession } from "next-auth/react";
import CategoryFilter from '@/components/CategorySelector';
import TextInput from '@/components/TextInput';
import NumberInput from '@/components/NumberInput';

export default function AddOrEditDemand({demand}) {

    const { data: session } = useSession();


    function submitHandler() {
        
        console.log("Demand: "+JSON.stringify(demand))
        const demandUrl = "/.rest/linkdemands"
        const requestedDate = new Date(demand.requested)
        demand.requested = requestedDate.toISOString()

        if(demand.categories && demand.categories[0].name) {
            demand.categories = demand.categories.map((c)=>c.value ? c.value : c._links.self.href)
        }

        if(demand.id) {
            fetch(demandUrl+"/"+demand.id, {
                method: 'PATCH',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(demand)
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
                }
                else {
                    console.log("Created failed");
                }
            });
        }

        location.href = "/demand";
    }

    function categoryChangeHandler(categories) {
        const categoryHrefs = categories.map(c => c.value)
        demand.categories = categoryHrefs
    }

    return (
        <>
            <div className="content-center mb-4">
                <button id="createnew" onClick={submitHandler} 
                    className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 p-4 border border-blue-700 rounded">
                    Submit
                </button>
            </div>
            <div>
            <form className="w-full max-w-lg card">
                <div className="flex flex-wrap -mx-3 mb-6">
                    <div className="w-full md:w-1/2 px-3 mb-6 md:mb-0">
                        <TextInput label="name" changeHandler={(e)=>demand.name=e} initialValue={demand.name}/>
                    </div>
                    <div className="w-full md:w-1/2 px-3">
                        <TextInput label="Anchor text" changeHandler={(e)=>demand.anchorText=e} initialValue={demand.anchorText} />
                    </div>
                </div>
                <div className="flex flex-wrap -mx-3 mb-6">
                    <div className="w-full px-3">
                        <TextInput label="URL" changeHandler={(e)=>demand.url=e} initialValue={demand.url} />
                    </div>
                </div>
                <div className="flex flex-wrap -mx-3 mb-2">
                    <div className="w-full md:w-1/3 px-3 mb-6 md:mb-0">
                        <NumberInput label="DA needed" changeHandler={(e)=>demand.daNeeded=e} initialValue={demand.daNeeded} />
                    </div>
                    <div className="w-full md:w-2/3 px-3 mb-6 md:mb-0">
                        <CategorySelector changeHandler={categoryChangeHandler} label="Categories" initialValue={demand.categories}/>
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
        </>
    );
}