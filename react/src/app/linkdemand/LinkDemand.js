'use client'

import React from 'react';
import './LinkDemand.css';
import LinkDemandCard from '@/components/linkdemandcard';

class LinkDemand extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            error: null,
            isLoaded: false,
            linkdemands: []
    ***REMOVED***;
        this.myRef = React.createRef();
***REMOVED***

    componentDidMount() {
        const url = 'http://localhost:8080/linkdemands';

        fetch(url)
            .then(res => res.json())
            .then((result) => this.setState({
                    isLoaded: true, 
                    linkdemands: result})
            ).catch(error => this.myRef.current.innerHTML = 'Error connecting to API: '+ error);
***REMOVED***

    parseId(linkdemand) {
        const url = linkdemand._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
***REMOVED***

    render() {
        const { isLoaded, club } = this.state;
        if (!isLoaded) {
            return <div ref={this.myRef}>Loading...</div>;
    ***REMOVED*** else {
            return (
                <>
                    <ul>
                        {this.state.linkdemands._embedded.linkdemands.map(ld => (
                            <li>
                                <a href={'/supplier/search/'+this.parseId(ld)}>
                                    <LinkDemandCard linkdemand={ld} />
                                </a>
                            </li>
                        ))}
                    </ul>
                </>
            )
        ***REMOVED***
***REMOVED***
}

export default LinkDemand;