'use client'

import '@/styles/globals.css'
import React, {useState, useEffect} from 'react'

export default function CategoriesCard(props) {
    const [categories, setCategories] = useState(null);
    
    useEffect(
        () => {      
            console.log("Loading categories, using URL "+props.categoriesUrl);
            fetch(props.categoriesUrl)
                .then(res => res.json())
                .then((c) => setCategories(c)
                );
            
        }, []
    );

    if(categories === null) return <p>NULL</p>;
    else return (
        <div className="card">
            {categories._embedded.categories.map( (c) => <div>{c.name}</div>)}
        </div>
    );
}