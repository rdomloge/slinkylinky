import '@/styles/globals.css'
import React, {useState, useEffect} from 'react'
import Category, { CategoryLite } from './category';

export default function CategoriesCard({categories}) {
    

    return (
        <>
        {categories ?
            <div className="child-card flex flex-wrap">
                {categories.filter(c => c.disabled == false).map( (c,index) => <CategoryLite category={c} key={index}/> )}
            </div>
        : null}
        </>
    );
}