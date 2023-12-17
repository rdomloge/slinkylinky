'use client'

import React, {useState} from 'react'
import CategorySelector from "@/components/CategorySelector";
import { useSession } from "next-auth/react";
import TextInput from '@/components/atoms/TextInput';
import NumberInput from '@/components/atoms/NumberInput';


export default function AddOrEditDemandSite({demandSite}) {

    const { data: session } = useSession();
    


    function submitHandler() {
        
        console.log("Demand: "+JSON.stringify(demandSite))
        const demandSiteUrl = "/.rest/demandsites"
        const requestedDate = new Date(demandSite.requested)
        // demandSite.requested = requestedDate.toISOString()

        if(demandSite.categories && demandSite.categories[0].name) {
            demandSite.categories = demandSite.categories.map((c)=>c.value ? c.value : c._links.self.href)
        }

        if(demandSite.id) {
            fetch(demandSiteUrl+"/"+demandSite.id, {
                method: 'PATCH',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(demandSite)
            }).then(resp => {
                if(resp.ok) {
                    location.href = "/demandsites";
                }
                else {
                    console.log("Patch failed: "+JSON.stringify(resp))
                }
            })
        }
    //     else {
    //         demandSite.createdBy = session.user.email
    //         fetch(demandSiteUrl, {
    //             method: 'POST',
    //             headers: {'Content-Type':'application/json'},
    //             body: JSON.stringify(demandSite)
    //         })
    //         .then( (resp) => {
    //             if(resp.ok) {
    //                 const locationUrl = resp.headers.get('Location')
    //                 console.log("New demandSite created at "+locationUrl)
    //                 location.href = "/demandSite";
    //             }
    //             else {
    //                 console.log("Created failed: "+JSON.stringify(resp));
    //             }
    //         });
        }

        
    // }

    function categoryChangeHandler(categories) {
        const categoryHrefs = categories.map(c => c.value)
        demandSite.categories = categoryHrefs
    }

    return (
        <div className="flex">
            <div className="flex-1">
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
                            <TextInput label="name" initialValue={demandSite.name} changeHandler={(e)=>{
                                demandSite.name=e
                                setSearchTerm(e)
                            }} />
                        </div>
                    </div>
                    <div className="flex flex-wrap -mx-3 mb-6">
                        <div className="w-full px-3">
                            <TextInput label="URL" changeHandler={(e)=>demandSite.url=e} initialValue={demandSite.url}/>
                        </div>
                    </div>
                    <div className="flex flex-wrap -mx-3 mb-2">
                        <div className="w-full md:w-2/3 px-3 mb-6 md:mb-0">
                            <CategorySelector changeHandler={categoryChangeHandler} label="Categories" initialValue={demandSite.categories}/>
                        </div>
                        
                    </div>
                    </form>
                </div>
            </div>
           
        </div>
    );
}