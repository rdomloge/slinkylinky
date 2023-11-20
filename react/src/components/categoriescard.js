'use client'

import '@/styles/globals.css'
import React, {useState, useEffect} from 'react'
import Category from './category';

export default function CategoriesCard(props) {
    const [categories, setCategories] = useState(null);
    
    useEffect(
        () => {      
            console.log("Loading categories, using URL "+props.categoriesUrl);
            fetch(props.categoriesUrl)
                .then(res => res.json())
                .then((c) => setCategories(c)
                );
            
    ***REMOVED***, []
    );

    if(categories === null) return <p>...</p>;
    else return (
        <div className="child-card">
            {categories._embedded.categories.map( (c) => <Category name={c.name}/>)}
        </div>
    );
}