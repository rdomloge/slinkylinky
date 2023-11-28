'use client'

import '@/styles/globals.css'
import Link from 'next/link';

export default function Menu() {
    
    return (
        <div className="pt-5 px-3">
            <div><Link href="/">Demand</Link></div>
            <div><Link href="/categories">Categories</Link></div>
            <div><Link href="/supplier">Suppliers</Link></div>
            <div><Link href="/proposals">Proposals</Link></div>
            <div><Link href="/paidlinks">Paid links</Link></div>
        </div>
    );
}