from flask import Flask, jsonify
import json

app = Flask(__name__)

def load_users():
    with open('users.json', 'r', encoding='utf-8') as f:
        return json.load(f)

@app.route('/users', methods=['GET'])
def get_users():
    users = load_users()
    return jsonify(users)

if __name__ == '__main__':
    app.run(debug=True)

