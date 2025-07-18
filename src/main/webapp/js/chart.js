/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


function renderRadarChart(labels, scores) {
    const ctx = document.getElementById('radarChart').getContext('2d');
    if (window.radarChartInstance) {
        window.radarChartInstance.destroy();
    }
    window.radarChartInstance = new Chart(ctx, {
        type: 'radar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Điểm kỹ năng',
                data: scores,
                fill: true,
                backgroundColor: 'rgba(99,102,241,0.18)',
                borderColor: 'rgba(59,130,246,1)',
                borderWidth: 3,
                pointBackgroundColor: 'rgba(59,130,246,1)',
                pointBorderColor: '#fff',
                pointHoverBackgroundColor: '#fff',
                pointHoverBorderColor: 'rgba(59,130,246,1)',
                pointRadius: 6,
                pointHoverRadius: 9
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: false
                },
                title: {
                    display: false
                },
                tooltip: {
                    enabled: true,
                    callbacks: {
                        label: function(context) {
                            return context.label + ': ' + context.formattedValue;
                        }
                    }
                }
            },
            scales: {
                r: {
                    angleLines: { display: true, color: '#e0e7ef' },
                    grid: { color: '#e0e7ef' },
                    suggestedMin: 0,
                    suggestedMax: 100,
                    pointLabels: {
                        font: { size: 18, weight: 'bold' },
                        color: '#3b3b5c',
                        padding: 8
                    },
                    ticks: {
                        stepSize: 20,
                        font: { size: 14 },
                        color: '#64748b',
                        showLabelBackdrop: false,
                        callback: function(value) {
                            // Chỉ hiển thị tick chính (0, 20, 40, ...)
                            return value % 20 === 0 ? value : '';
                        }
                    }
                }
            },
            animation: {
                duration: 1200,
                easing: 'easeOutElastic'
            }
        }
    });
}


