import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend,
  } from 'chart.js';
import { Line } from "react-chartjs-2";

export default function LineGraph({datapoints}) {
    ChartJS.register(
        CategoryScale,
        LinearScale,
        PointElement,
        LineElement,
        Title,
        Tooltip,
        Legend
      );

    const labels = datapoints.map((datapoint) => {
        return datapoint.yearMonth;
***REMOVED***);

    const data = {
        labels, 
        datasets: [
            {
                label: "Traffic",
                data: datapoints.map((datapoint) => datapoint.traffic),
                borderColor: 'rgb(255, 99, 132)',
                backgroundColor: 'rgba(255, 99, 132, 0.5)',
        ***REMOVED***
        ]
***REMOVED***

    return (
        <Line data={data} />
    )
}


