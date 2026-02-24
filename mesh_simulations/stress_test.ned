import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;

import inet.physicallayer.common.packetlevel.RadioMedium;

import inet.physicallayer.propagation.ConstantSpeedPropagation;

import inet.visualizer.integrated.IntegratedVisualizer;

import inet.linklayer.ieee80211mesh.nodes.HostMesh;
import inet.node.inet.AdhocHost;
import inet.node.aodv.AODVRouter;


import inet.common.scenario.ScenarioManager;
import inet.common.lifecycle.LifecycleController;




network mesh_sim
{
    parameters:
        @statistic[packetJitter];
        @display("bgb=3000,3000");


        int numServers;
        int numRelays;
        int numClients;
        
        

    submodules:
        Router[numRelays]: AdhocHost {
            @display("p=570.76,456.60803");
        }
        clients[numClients]: AdhocHost {
            @display("p=900.4375,900.3625");
        }
        server[numServers]: AdhocHost {
            @display("p=800.96,1000.744");
        }
        radioMedium: RadioMedium {
            @display("p=503,184");
        }
        constantSpeedPropagation: ConstantSpeedPropagation {
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

network hwmp_sim
{
    parameters:
        @statistic[packetJitter];
        @display("bgb=3000,3000");


        int numServers;
        int numRelays;
        int numClients;


    submodules:
        Router[numRelays]: HostMesh {
            @display("p=570.76,456.60803");
        }
        clients[numClients]: HostMesh {
            @display("p=900.4375,900.3625");
        }
        server[numServers]: HostMesh {
            @display("p=800.96,1000.744");
        }
        radioMedium: RadioMedium {
            @display("p=503,184");
			            
        }
        constantSpeedPropagation: ConstantSpeedPropagation {
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

network aodv_sim
{
    parameters:
        @display("bgb=3000,3000");

        int numServers;
        int numRelays;
        int numClients;

    submodules:
        Router[numRelays]: AODVRouter {
            @display("p=570.76,456.60803");
        }
        clients[numClients]: AODVRouter {
            @display("p=900.4375,900.3625");
        }
        server[numServers]: AODVRouter {
            @display("p=800.96,1000.744");
        }
        radioMedium: RadioMedium {
            @display("p=503,184");
			            
        }
        constantSpeedPropagation: ConstantSpeedPropagation {
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