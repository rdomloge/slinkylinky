'use client'

import '@/styles/globals.css'

export default function Menu() {
    
    return (
        <div className="pt-5 px-3">
            <div><a href="/">Demand</a></div>
            <div><a href="/categories">Categories</a></div>
            <div><a href="/supplier">Suppliers</a></div>
            <div>Paid links</div>
        </div>
    );
}