import inet.node.aodv.AODVRouter;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.visualizer.integrated.IntegratedVisualizer;
import inet.physicallayer.common.packetlevel.RadioMedium;
import inet.physicallayer.propagation.ConstantTimePropagation;

import inet.networklayer.ipv4.RoutingTableRecorder;




network aodv_sim
{
    parameters:
        @display("bgb=3000,3000");

        int numServers;
        int numRelays;
        int numClients;

    submodules:
        batman5Router[numRelays]: AODVRouter {
            @display("p=570.76,456.60803");
        }
        clients[numClients]: AODVRouter {
            @display("p=175.4375,175.3625");
        }
        server[numServers]: AODVRouter {
            @display("p=2800.96,2000.744");
        }
        radioMedium: RadioMedium {
            @display("p=503,184");
        }
        constantTimePropagation: ConstantTimePropagation {
            @display("p=571.16003,222.296");
        }
        configurator: IPv4NetworkConfigurator {
            @display("p=576.768,408.544");
        }
        visualizer: IntegratedVisualizer {
            @display("p=273.08798,224.896");
        }
        routingTableRecorder: RoutingTableRecorder {
            parameters:
                @display("p=50,150");
        }
}
