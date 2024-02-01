'use client'

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import React, {useState, useEffect} from 'react'
import Loading from "@/components/Loading";
import { SessionBlock, StyledButton } from "@/components/atoms/Button";
import Modal from "@/components/atoms/Modal";
import TextInput from "@/components/atoms/TextInput";
import { useSession } from "next-auth/react";
import ErrorMessage, { InfoMessage, WarningMessage } from "@/components/atoms/Messages";
import DisableToggle from "@/components/atoms/DisableToggle";

export default function ListCategories() {
    const [categories, setCategories] = useState()
    const [error, setError] = useState()
    const [showNewModal, setShowNewModal] = useState(false);
    const [showEditModal, setShowEditModal] = useState(false);
    const [newCategoryName, setNewCategoryName] = useState();
    const { data: session } = useSession();
    
    const [editingCategory, setEditingCategory] = useState();
    const [editingCategoryName, setEditingCategoryName] = useState();

    const catUrl = "/.rest/categories/search/findAllByOrderByNameAsc";
    const patchUrl = "/.rest/categories/";

    useEffect(
        () => {
            fetch(catUrl)
                .then( (res) => res.json())
                .then( (data) => setCategories(data))
                .catch( (error) => setError(error));
    ***REMOVED***, []
    );

    function createCategory() {
        console.log("Creating category: "+newCategoryName);
        var newCategory = {name: newCategoryName, disabled: false, createdBy: session.user.email}
        

        setCategories(categories);
        fetch(patchUrl, {
            method: 'POST',
            headers: {'Content-Type':'application/json', 'user': session.user.email},
            body: JSON.stringify(newCategory)
    ***REMOVED***)
        .then( (resp) => {
            if(resp.ok) {
                const locationUrl = resp.headers.get('Location')
                newCategory.id = locationUrl.substring(locationUrl.lastIndexOf("/")+1)
                const newCategories = categories.concat(newCategory)
                newCategories.sort((a,b) => {
                    if(a.name)
                        return a.name.localeCompare(b.name)
                    else
                        console.log("No name for "+JSON.stringify(a))
                    return -1
            ***REMOVED***)
                setCategories(newCategories);
        ***REMOVED***
            else {
                console.log("Created failed: "+JSON.stringify(resp));
        ***REMOVED***
    ***REMOVED***)
        setShowNewModal(false);
***REMOVED***

    function editCategory(category) {
        setShowEditModal(true);
        setEditingCategory(category);
        setEditingCategoryName(category.name);
***REMOVED***

    function saveUpdatedCategory() {
        console.log("Saving updated category: "+editingCategoryName);
        setShowEditModal(false);
        
        fetch(patchUrl + editingCategory.id, {
            method: 'PATCH',
            headers: {'Content-Type':'application/json', 'user': session.user.email},
            body: JSON.stringify({name: editingCategoryName, disabled: editingCategory.disabled, updatedBy: session.user.email})
    ***REMOVED***)
***REMOVED***

    
    return (
        <Layout>
            <PageTitle title="Categories" count={categories}/>
            <StyledButton label="New" type="primary" extraClass="mb-8" submitHandler={()=>setShowNewModal(true)} enabled={session}/>
            {categories ?
                <div className="grid grid-cols-4">
                        {categories.map( (c,index) => {
                            return (
                                <div className={"font-bold text-xl p-2 border rounded-full m-1 p-2 bg-slate-100 "+(c.disabled?"line-through":"")} key={index}>
                                    {c.name} 
                                    {session ?
                                        <>
                                        <StyledButton label="Edit" type="secondary" isText={true} extraClass="float-right font-light text-sm" 
                                            submitHandler={()=>editCategory(c)}/>
                                        </>
                                        : null
                                ***REMOVED***
                                </div>
                        )})}
                </div>
            : 
                <Loading error={error}/>
        ***REMOVED***
            {showNewModal ?
                <Modal dismissHandler={()=>setShowNewModal(false)} title="New category" >
                    <TextInput label="Category name" changeHandler={(e)=>setNewCategoryName(e)}/>
                    <StyledButton label="Create" submitHandler={()=>createCategory()}/>
                </Modal>
            : 
                null
        ***REMOVED***
            {showEditModal ?
                <Modal dismissHandler={()=>setShowEditModal(false)} title="Edit category" >
                    <TextInput label="Category name" initialValue={editingCategoryName} disabled={true} />
                    
                    <WarningMessage message="Disabling a category means that demandsites will no longer populate demand with this category." 
                        messageClass="text-yellow-700 text-sm inline-block" 
                        iconWidth={24} 
                        iconHeight={24}/>
                    <WarningMessage message="Suppliers will no longer match on this category." 
                        messageClass="text-yellow-700 text-sm inline-block" 
                        iconWidth={24} 
                        iconHeight={24}/>
                    <InfoMessage message="Categories cannot be renamed - disable this one and create a new one."
                        messageClass="text-blue-700 text-sm inline-block" 
                        iconWidth={24} 
                        iconHeight={24}/>
                    <DisableToggle label="Disable" initialValue={editingCategory.disabled?true:false} changeHandler={(e)=>editingCategory.disabled=e}/>
                    <div className="flex-1 flex justify-end inline-block">
                        <StyledButton label="Update" submitHandler={()=>saveUpdatedCategory()} type="risky"/>
                    </div>
                </Modal>
            :
                null
        ***REMOVED***
        </Layout>
    );
    
}