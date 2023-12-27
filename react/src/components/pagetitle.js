'use client'

import '@/styles/globals.css'

export default function PageTitle(props) {
    return (
        <div className="pageTitle">
            {props.title} {props.count ? " ("+props.count.length+")" : ""}
        </div>
    )
}