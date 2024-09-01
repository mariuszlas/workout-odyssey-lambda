exports.handler = async (event) => {
    try {
        const result = await fetch("https://workoutodyssey.com");
        return `Successfull request: ${result.status}`;
    } catch (_) {
        return "Request failed";
    }
};
