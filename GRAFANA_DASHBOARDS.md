# Grafana Dashboard IDs for Import

## Required for Atelier:

1. **Kubernetes Cluster** - ID: `315`
   - Cluster overview, node resources, pod status
   - Covers: Kubernetes monitoring requirement

2. **Node Exporter Full** - ID: `1860`
   - CPU, memory, disk, network metrics
   - Covers: "Machine Ubuntu" monitoring

3. **Spring Boot Statistics** - ID: `11378`
   - JVM metrics, HTTP requests, database connections
   - Covers: "Application Spring" monitoring
   - Note: Will show data when Spring Boot actuator is enabled

4. **Jenkins Performance** - ID: `9964`
   - Build success rates, execution times, queue length
   - Covers: "Jenkins" monitoring

## Import Steps:
1. Go to http://127.0.0.1:36799
2. Login with admin/admin
3. Click "+" → "Import"
4. Enter one of the IDs above
5. Select "Prometheus" as datasource
6. Click "Import"
7. Repeat for each dashboard

## Alternative Dashboards (Optional):
- ID `6417` - Spring Boot HikariCP Dashboard
- ID `10795` - JVM (Micrometer) Dashboard
- ID `11074` - Node Exporter Quickstart
