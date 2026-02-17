import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.physicallayer.common.packetlevel.RadioMedium;
import inet.physicallayer.propagation.ConstantTimePropagation;
import inet.visualizer.integrated.IntegratedVisualizer;
import inet.node.inet.AdhocHost;
import inet.common.scenario.ScenarioManager;
import inet.common.lifecycle.LifecycleController;






network batman_inetmanet_sim
{
    parameters:
        @statistic[packetJitter];
        @display("bgb=3000,3000");


        int numServers;
        int numRelays;
        int numClients;
        

    submodules:
        batman5Router[numRelays]: AdhocHost {
            //wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");  // use adhoc management
            //@display("p=245.025,198.45");
            @display("p=570.76,456.60803");
        }
        clients[numClients]: AdhocHost {
            //wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");  // use adhoc management
            @display("p=900.4375,900.3625");
            //@display("p=200.35202,200.744");
        }
        server[numServers]: AdhocHost {
            //wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");  // use adhoc management
            //@display("p=700, 700");
            @display("p=800.96,1000.744");
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
        scenarioManager: ScenarioManager {
            parameters:
                script = default(xml("<scenario/>"));
                @display("p=50,250");
        }
        lifecycleController: LifecycleController {
            parameters:
                @display("p=50,200");
        }
}
