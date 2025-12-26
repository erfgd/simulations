
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
            wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");  // use adhoc management
            //@display("p=245.025,198.45");
            @display("p=1045.3921,504.67203");
        }
        clients[numClients]: Batman5Router {
            wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");  // use adhoc management
            //@display("p=35.4375,272.3625");
        }
        server[numServers]: Batman5Router {
            wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");  // use adhoc management
            //@display("p=700, 700");
            @display("p=270.36002,504.67203");
        }
        radioMedium: RadioMedium {
            @display("p=603,184");
        }
        constantTimePropagation: ConstantTimePropagation {
            @display("p=586,294");
        }
        configurator: IPv4NetworkConfigurator {
            @display("p=581,378");
        }

        visualizer: IntegratedVisualizer {
            @display("p=273.08798,224.896");
        }
}
