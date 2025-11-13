from ns import ns


# logging 
ns.LogComponentEnable("UdpEchoClientApplication", ns.LOG_LEVEL_INFO)
ns.LogComponentEnable("UdpEchoServerApplication", ns.LOG_LEVEL_INFO)
ns.LogComponentEnable("AodvRoutingProtocol", ns.LOG_LEVEL_INFO)
ns.LogComponentEnable("Ipv4L3Protocol", ns.LOG_LEVEL_INFO)


ns.LogComponentEnable("Ipv4RoutingProtocol", ns.LOG_LEVEL_INFO)
ns.LogComponentEnable("AodvRoutingTable", ns.LOG_LEVEL_INFO)


#constants
NUM_RELAYS = 16
routers_num = NUM_RELAYS
NUM_SERVERS = 1
NUM_CLIENTS = 1
step = 10
MAX_X = step * (int(routers_num**0.5) - 1)
STEP = 10
MAX_Y = step * (routers_num // int(routers_num**0.5) - 1)


#ranking functions
def create_grid_relays(num_nodes, step):

    relays = ns.NodeContainer()
    relays.Create(num_nodes)

    mobility = ns.MobilityHelper()
    mobility.SetPositionAllocator(
        "ns3::GridPositionAllocator",
        "MinX", ns.DoubleValue(0.0),
        "MinY", ns.DoubleValue(0.0),
        "DeltaX", ns.DoubleValue(step),
        "DeltaY", ns.DoubleValue(step),
        "GridWidth", ns.UintegerValue(int(num_nodes**0.5)),  # количество узлов в строке
        "LayoutType", ns.StringValue("RowFirst"),
    )
    mobility.SetMobilityModel("ns3::ConstantPositionMobilityModel")
    mobility.Install(relays)

    return relays


def create_random_nodes(num_nodes):
    nodes = ns.NodeContainer()
    nodes.Create(num_nodes)

    mobility = ns.MobilityHelper()
    mobility.SetPositionAllocator(
        "ns3::RandomRectanglePositionAllocator",
        "X", ns.StringValue(f"ns3::UniformRandomVariable[Min=0.0|Max={MAX_X}]"),
        "Y", ns.StringValue(f"ns3::UniformRandomVariable[Min=0.0|Max={MAX_Y}]")
    )
    # mobility.SetMobilityModel("ns3::ConstantPositionMobilityModel")
    mobility.SetMobilityModel(
        "ns3::RandomWalk2dMobilityModel",
        "Bounds", ns.RectangleValue(ns.Rectangle(0.0, MAX_X, 0.0, MAX_Y)),
        "Distance", ns.DoubleValue(10.0),  # расстояние одного шага
        "Speed", ns.StringValue("ns3::ConstantRandomVariable[Constant=2.0]"),  # скорость узлов
        "Time", ns.TimeValue(ns.Seconds(1.0))  # обновление направления раз в секунду
    )
    
    mobility.Install(nodes)
    return nodes


relays = create_grid_relays(NUM_RELAYS, STEP)
servers = create_random_nodes(NUM_SERVERS)
clients = create_random_nodes(NUM_CLIENTS)


# Настройка двух отдельных каналов
wifi_channel1 = ns.YansWifiChannelHelper.Default()
wifi_channel1.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel")

wifi_channel2 = ns.YansWifiChannelHelper.Default()
wifi_channel2.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel")


# Первый канал - для клиентов и ретрансляторов, vторой канал - для серверов и ретрансляторов  
wifi_phy1 = ns.YansWifiPhyHelper()
wifi_phy1.SetChannel(wifi_channel1.Create())

wifi_phy2 = ns.YansWifiPhyHelper()
wifi_phy2.SetChannel(wifi_channel2.Create())


# Настройка Wi-Fi
wifi = ns.WifiHelper()
wifi.SetRemoteStationManager("ns3::ConstantRateWifiManager", 
                            "DataMode", ns.StringValue("OfdmRate6Mbps"))

wifi_mac = ns.WifiMacHelper()
wifi_mac.SetType("ns3::AdhocWifiMac")


# Создаем устройства для первого канала (клиенты + ретрансляторы), для второго канала (серверы + ретрансляторы)
client_relay_nodes = ns.NodeContainer(clients, relays)
devices_channel1 = wifi.Install(wifi_phy1, wifi_mac, client_relay_nodes)

server_relay_nodes = ns.NodeContainer(servers, relays)
devices_channel2 = wifi.Install(wifi_phy2, wifi_mac, server_relay_nodes)


# Устанавливаем стек TCP/IP + AODV
stack = ns.InternetStackHelper()
aodv = ns.AodvHelper()
stack.SetRoutingHelper(aodv)
stack.Install(clients)
stack.Install(servers)
stack.Install(relays)


# Назначаем IP-адреса для разных каналов
# Первая сеть: клиенты и ретрансляторы, Вторая сеть: серверы и ретрансляторы
address_helper = ns.Ipv4AddressHelper()

address_helper.SetBase(ns.Ipv4Address("10.1.1.0"), ns.Ipv4Mask("255.255.255.0"))
interfaces_channel1 = address_helper.Assign(devices_channel1)


address_helper.SetBase(ns.Ipv4Address("10.1.2.0"), ns.Ipv4Mask("255.255.255.0"))
interfaces_channel2 = address_helper.Assign(devices_channel2)


# Включаем форвардинг на ретрансляторах
for i in range(relays.GetN()):
    node = relays.Get(i)
    ipv4 = node.GetObject[ns.Ipv4]()
    # Включаем форвардинг для всех интерфейсов
    for j in range(ipv4.GetNInterfaces()):
        ipv4.SetForwarding(j, True)


# Настройка приложений
# UDP Echo серверы на серверах
echo_server = ns.UdpEchoServerHelper(9)
server_apps = echo_server.Install(servers)
server_apps.Start(ns.Seconds(1.0))
server_apps.Stop(ns.Seconds(20.0))

for i in range(clients.GetN()):
    client_address = interfaces_channel1.GetAddress(i)
    print(f"Client {i} IP address: {client_address}")


# UDP Echo клиенты на клиентах
for i in range(servers.GetN()):
    # Получаем IP-адрес сервера из интерфейсов
    server_address = interfaces_channel2.GetAddress(i)
    print(f"Server {i} IP address: {server_address}")
    
    for j in range(clients.GetN()):
        # Создаем InetSocketAddress правильно
        ipv4_addr = ns.Ipv4Address(server_address)
        
        echo_client = ns.UdpEchoClientHelper(ipv4_addr.ConvertTo(), 9)
        echo_client.SetAttribute("MaxPackets", ns.UintegerValue(10))
        echo_client.SetAttribute("Interval", ns.TimeValue(ns.Seconds(1.0)))
        echo_client.SetAttribute("PacketSize", ns.UintegerValue(512))
        
        client_app = echo_client.Install(clients.Get(j))
        client_app.Start(ns.Seconds(2.0 + i * 0.5 + j * 0.1))
        client_app.Stop(ns.Seconds(15.0))



# Визуализация через NetAnim, рекомендуемая версия Netamim 3.108
anim = ns.AnimationInterface("aodv_3_trace.xml")
anim.EnablePacketMetadata(True)
for i in range(NUM_RELAYS):
    #anim.UpdateNodeDescription(relays.Get(i), "RELAY")
    anim.UpdateNodeColor(relays.Get(i), 0, 0, 200)
for i in range(NUM_CLIENTS):
    #anim.UpdateNodeDescription(clients.Get(i), "CLIENT")
    anim.UpdateNodeColor(clients.Get(i), 0, 200, 0)
for i in range(NUM_SERVERS):
    #anim.UpdateNodeDescription(servers.Get(i), "SERVER")
    anim.UpdateNodeColor(servers.Get(i), 200, 0, 0)


print("Starting simulation...")
print("Network topology:")
print(f"Clients: {NUM_CLIENTS} nodes in network 10.1.1.0/24")
print(f"Relays: {NUM_RELAYS} nodes with interfaces in both networks")
print(f"Servers: {NUM_SERVERS} nodes in network 10.1.2.0/24")
print("Traffic must flow through relays!")

ascii = ns.AsciiTraceHelper()
stream = ascii.CreateFileStream("trace_ascii.tr")
wifi_phy1.EnableAsciiAll(stream)
wifi_phy2.EnableAsciiAll(stream)


flowMonitor = ns.FlowMonitorHelper()
monitor = flowMonitor.InstallAll()

ns.Simulator.Stop(ns.Seconds(20.0))
ns.Simulator.Run()

flowMonitor.SerializeToXmlFile("flow_stats.xml", True, True)

ns.Simulator.Destroy()


print(f"End simulation")