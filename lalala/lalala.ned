
//package inet.examples.adhoc.batmanadv;

import inet.Batman5.node.Batman5Router;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.networklayer.configurator.ipv4.IPv4NodeConfigurator;
import inet.physicallayer.common.packetlevel.RadioMedium;
import inet.physicallayer.contract.packetlevel.IPropagation;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211RadioMedium;
import inet.physicallayer.propagation.ConstantTimePropagation;
import inet.visualizer.integrated.IntegratedVisualizer;



network lalala
{
    parameters:
        @display("bgb=3000,3000");

        int numServers;
        int numRelays;
        int numClients;

    submodules:
        batman5Router[numRelays]: Batman5Router {
            @display("p=570.76,456.60803");
        }
        clients[numClients]: Batman5Router {
            @display("p=175.4375,175.3625");
        }
        server[numServers]: Batman5Router {
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
}
