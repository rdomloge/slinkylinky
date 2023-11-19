'use client'

import React from 'react';
import './LinkDemand.css';


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
                    <div>This is some demand</div>
                    <ul>
                        {this.state.linkdemands._embedded.linkdemands.map(ld => (
                            <li>{ld.name} {ld.url} 
                            <a href={'http://localhost:8080/bloggers/search/findBloggersForLinkDemandId?linkDemandId='+this.parseId(ld)}>GO</a></li>
                        ))}
                    </ul>
                </>
            )
            }
    }
}

export default LinkDemand;