const { Kafka } = require("kafkajs");

async function run() {
  try {
    const kafka = new Kafka({
      "clientId": "test-app",
      "brokers": ["kafka-0.kafka-headless.default.svc.cluster.local:9092"]
    })

    const admin = kafka.admin();

    console.log("Connecting.....")
    await admin.connect()
    console.log("Connected!")

    await admin.createTopics({
      "topics": [{
        "topic": "Users",
        "numPartitions": 2
      }]
    });

    console.log("Created Successfully!")
    await admin.disconnect();
  }
  catch (ex) {
    console.error(`ERROR: ${ex}`)
  }
  finally {
    process.exit(0);
  }
}

run();
