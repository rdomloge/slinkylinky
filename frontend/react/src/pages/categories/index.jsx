import Layout from "@/components/layout/Layout";
import { BADGE_COLORS, hashName } from "@/components/Category";
import React, {useState, useEffect} from 'react'
import Loading from "@/components/Loading";
import { StyledButton } from "@/components/atoms/Button";
import Modal from "@/components/atoms/Modal";
import TextInput from "@/components/atoms/TextInput";
import { useAuth } from "@/auth/AuthProvider";
import { fetchWithAuth } from "@/utils/fetchWithAuth";
import { InfoMessage, WarningMessage } from "@/components/atoms/Messages";
import DisableToggle from "@/components/atoms/Toggle";
import { AuthorizedAccess } from "@/components/AuthorizedAccess";

export default function ListCategories() {
    const [categories, setCategories] = useState()
    const [error, setError] = useState()
    const [showNewModal, setShowNewModal] = useState(false);
    const [showEditModal, setShowEditModal] = useState(false);
    const [newCategoryName, setNewCategoryName] = useState();
    const { user } = useAuth();
    
    const [editingCategory, setEditingCategory] = useState();
    const [editingCategoryName, setEditingCategoryName] = useState();

    const catUrl = "/.rest/categories/search/findAllByOrderByNameAsc";
    const categoriesUrl = "/.rest/categories";

    useEffect(
        () => {
            if( ! user) return;
            fetchWithAuth(catUrl)
                .then( (res) => res.json())
                .then( (data) => setCategories(data))
                .catch( (error) => setError(error));
        }, []
    );

    function createCategory() {
        console.log("Creating category: "+newCategoryName);
        var newCategory = {name: newCategoryName, disabled: false, createdBy: user.email}
        

        setCategories(categories);
        fetchWithAuth(categoriesUrl, {
            method: 'POST',
            headers: {'Content-Type':'application/json', 'user': user.email},
            body: JSON.stringify(newCategory)
        })
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
                })
                setCategories(newCategories);
            }
            else {
                console.log("Created failed: "+JSON.stringify(resp));
            }
        })
        setShowNewModal(false);
    }

    function editCategory(category) {
        setShowEditModal(true);
        setEditingCategory(category);
        setEditingCategoryName(category.name);
    }

    function saveUpdatedCategory() {
        console.log("Saving updated category: "+editingCategoryName);
        setShowEditModal(false);
        
        fetchWithAuth(categoriesUrl + "/" + editingCategory.id, {
            method: 'PATCH',
            headers: {'Content-Type':'application/json', 'user': user.email},
            body: JSON.stringify({name: editingCategoryName, disabled: editingCategory.disabled, updatedBy: user.email})
        })
    }

    
    return (
        <Layout pagetitle="Categories">
            <div className="flex items-center justify-between px-6 pt-6 pb-4">
                <h1 id="category-list-id" className="pageTitle">
                    Categories
                    {categories && <span className="text-slate-400 font-normal text-2xl ml-2">({categories.length})</span>}
                </h1>
                <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                    <StyledButton label="New" type="primary" extraClass="!m-0" submitHandler={()=>setShowNewModal(true)} enabled={!!user}/>
                </AuthorizedAccess>
            </div>
            {categories ?
                <div className="flex flex-wrap gap-3 px-6 pb-6">
                    {categories.map( (c,index) => {
                        const colorClass = BADGE_COLORS[hashName(c.name) % BADGE_COLORS.length];
                        return (
                            <div className={`inline-flex items-center gap-2 px-5 py-2.5 rounded-full border text-base font-medium ${colorClass} ${c.disabled ? 'opacity-40 line-through' : ''}`} key={index}>
                                {c.name}
                                <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                                    <StyledButton label="Edit" type="secondary" isText={true} extraClass="!text-inherit opacity-60 hover:opacity-100 !text-xs !m-0"
                                        submitHandler={()=>editCategory(c)}/>
                                </AuthorizedAccess>
                            </div>
                        )
                    })}
                </div>
            : 
                <Loading error={error}/>
            }
            {showNewModal ?
                <Modal dismissHandler={()=>setShowNewModal(false)} title="New category" >
                    <TextInput label="Category name" binding={newCategoryName} changeHandler={(e)=>setNewCategoryName(e)}/>
                    <StyledButton label="Create" submitHandler={()=>createCategory()}/>
                </Modal>
            : 
                null
            }
            {showEditModal ?
                <Modal dismissHandler={()=>setShowEditModal(false)} title="Edit category" >
                    <TextInput label="Category name" binding={editingCategoryName} disabled={true} />
                    
                    <WarningMessage message="Disabling a category means that demandsites will no longer populate demand with this category."/>
                    <WarningMessage message="Suppliers will no longer match on this category."/>
                    <InfoMessage message="Categories cannot be renamed - disable this one and create a new one."/>
                    <DisableToggle label="Disable" initialValue={editingCategory.disabled?true:false} changeHandler={(e)=>editingCategory.disabled=e}/>
                    <div className="flex-1 flex justify-end inline-block">
                        <StyledButton label="Update" submitHandler={()=>saveUpdatedCategory()} type="risky"/>
                    </div>
                </Modal>
            :
                null
            }
        </Layout>
    );
    
}