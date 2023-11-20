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
        };
        this.myRef = React.createRef();
    }

    componentDidMount() {
        const url = 'http://localhost:8080/linkdemands';

        fetch(url)
            .then(res => res.json())
            .then((result) => this.setState({
                    isLoaded: true, 
                    linkdemands: result})
            ).catch(error => this.myRef.current.innerHTML = 'Error connecting to API: '+ error);
    }

    parseId(linkdemand) {
        const url = linkdemand._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
    }

    render() {
        const { isLoaded, club } = this.state;
        if (!isLoaded) {
            return <div ref={this.myRef}>Loading...</div>;
        } else {
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
            }
    }
}

export default LinkDemand;