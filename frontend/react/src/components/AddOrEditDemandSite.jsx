import { useAuth } from "@/auth/AuthProvider";
import CategorySelector from "@/components/CategorySelector";
import TextInput from '@/components/atoms/TextInput';
import SessionButton from "./atoms/Button";
import { fixForPosting } from "./CategoryUtil";
import { useState } from "react";
import { fetchWithAuth } from "@/utils/fetchWithAuth";


export default function AddOrEditDemandSite({demandSite}) {

    const { user } = useAuth();
    const [demandSiteName, setDemandSiteName] = useState(demandSite.name)
    const [demandSiteUrl, setDemandSiteUrl] = useState(demandSite.url)

    function submitHandler() {
        
        console.log("Demand: "+JSON.stringify(demandSite))
        const restUrl = "/.rest/demandsites"
        delete demandSite.domain
        demandSite.name = demandSiteName
        demandSite.url = demandSiteUrl
                
        fixForPosting(demandSite)

        if(demandSite.id) {
            demandSite.updatedBy = user.email

            fetchWithAuth(restUrl+"/"+demandSite.id, {
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
    }

    function categoryChangeHandler(categories) {
        const categoryHrefs = categories.map(c => c.value)
        demandSite.categories = categoryHrefs
    }

    return (
        <div className="px-6 pb-6 max-w-2xl">
            <div className="bg-white rounded-xl border border-slate-200 shadow-sm p-6 flex flex-col gap-5">
                <TextInput label="Name" binding={demandSiteName} changeHandler={(e) => setDemandSiteName(e)}/>
                <TextInput label="URL" binding={demandSiteUrl} changeHandler={(e) => setDemandSiteUrl(e)}/>
                <CategorySelector changeHandler={categoryChangeHandler} label="Categories" initialValue={demandSite.categories}/>
                <div className="flex justify-end pt-2">
                    <SessionButton label="Save" clickHandler={submitHandler}/>
                </div>
            </div>
        </div>
    );
}