'use client'

import '@/styles/globals.css'
import React, {useState, useEffect} from 'react'
import Category from './category';

export default function CategoriesCard({categories}) {
    

    return (
        <div className="child-card">
            {categories.map( (c,index) => <Category category={c} key={index}/> )}
        </div>
    );
}