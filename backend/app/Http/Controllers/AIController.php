<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class AIController extends Controller
{
    /**
     * Handle AI Chat query.
     */
    public function chat(Request $request): JsonResponse
    {
        $data = $request->validate([
            'query' => 'required|string',
            'history' => 'array',
        ]);

        $query = $data['query'];
        $history = $data['history'] ?? [];

        $geminiKey = env('GEMINI_API_KEY');
        $openaiKey = env('OPENAI_API_KEY');

        $systemPrompt = "You are a professional and helpful Cambodian Culinary Chef named 'AI Culinary Assistant'. " .
                        "You have deep expertise in traditional Khmer ingredients (such as Kroeung, Prahok, Kampot Pepper), cooking techniques, and regional recipes. " .
                        "Provide rich, accurate, and structured culinary guidance. " .
                        "Keep answers relatively concise and highly helpful. You can chat in both Khmer and English.";

        // 1. Call Gemini API if Key is Configured (Recommended: generous free tier)
        if (!empty($geminiKey)) {
            try {
                // Map history to Gemini content structure
                $contents = [];
                
                // Set system instruction via content or query
                $contents[] = [
                    'role' => 'user',
                    'parts' => [['text' => "SYSTEM INSTRUCTION: " . $systemPrompt]]
                ];
                $contents[] = [
                    'role' => 'model',
                    'parts' => [['text' => "Understood. I will act as the AI Culinary Assistant with deep expertise in Cambodian cuisine."]]
                ];

                foreach ($history as $msg) {
                    $contents[] = [
                        'role' => $msg['sender'] === 'user' ? 'user' : 'model',
                        'parts' => [['text' => $msg['text']]]
                    ];
                }

                $contents[] = [
                    'role' => 'user',
                    'parts' => [['text' => $query]]
                ];

                $response = Http::timeout(10)
                    ->withoutVerifying()
                    ->post("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" . $geminiKey, [
                        'contents' => $contents
                    ]);

                if ($response->successful()) {
                    $resJson = $response->json();
                    $reply = $resJson['candidates'][0]['content']['parts'][0]['text'] ?? '';
                    if (!empty($reply)) {
                        return response()->json(['reply' => trim($reply)]);
                    }
                }
            } catch (\Exception $e) {
                Log::error("Gemini API error: " . $e->getMessage());
            }
        }

        // 2. Call OpenAI API if Key is Configured
        if (!empty($openaiKey)) {
            try {
                $messages = [
                    ['role' => 'system', 'content' => $systemPrompt]
                ];

                foreach ($history as $msg) {
                    $messages[] = [
                        'role' => $msg['sender'] === 'user' ? 'user' : 'assistant',
                        'content' => $msg['text']
                    ];
                }

                $messages[] = [
                    'role' => 'user',
                    'content' => $query
                ];

                $response = Http::timeout(10)
                    ->withoutVerifying()
                    ->withHeaders([
                        'Authorization' => 'Bearer ' . $openaiKey,
                        'Content-Type' => 'application/json'
                    ])
                    ->post('https://api.openai.com/v1/chat/completions', [
                        'model' => 'gpt-4o-mini',
                        'messages' => $messages,
                        'temperature' => 0.7
                    ]);

                if ($response->successful()) {
                    $resJson = $response->json();
                    $reply = $resJson['choices'][0]['message']['content'] ?? '';
                    if (!empty($reply)) {
                        return response()->json(['reply' => trim($reply)]);
                    }
                }
            } catch (\Exception $e) {
                Log::error("OpenAI API error: " . $e->getMessage());
            }
        }

        // 3. Smart Fallback if no keys configured
        $reply = $this->getFallbackResponse($query);
        return response()->json(['reply' => $reply]);
    }

    /**
     * Fallback responses for local culinary query.
     */
    private function getFallbackResponse(string $query): string
    {
        $q = strtolower(trim($query));
        $mockReply = '';

        if (str_contains($q, 'amok') || str_contains($q, 'អាម៉ុក')) {
            $mockReply = "For an authentic Cambodian Fish Amok, the secret is steaming the curry mousse inside hand-folded banana leaf cups lined with fresh noni leaves (Sleok Nhor) for exactly 20 minutes. The noni leaves add a unique, delicate bitter note that offsets the rich sweetness of coconut cream.";
        } else if (str_contains($q, 'kroeung') || str_contains($q, 'គ្រឿង')) {
            $mockReply = "Traditional Khmer Yellow Kroeung requires lemongrass stalks, fresh turmeric, galangal, kaffir lime zest, garlic, and shallots. For best flavor, pound them in a stone mortar and pestle rather than using a blender, as this releases the essential oils better!";
        } else if (str_contains($q, 'lok lak') || str_contains($q, 'ឡុកឡាក់')) {
            $mockReply = "When preparing Beef Lok Lak, stir-fry the marinated beef cubes in a smoking hot wok for only 2 to 3 minutes. Searing it quickly traps the natural juices inside. Always serve with a lime juice, sea salt, and fresh Kampot pepper dip.";
        } else if (str_contains($q, 'prahok') || str_contains($q, 'ប្រហុក')) {
            $mockReply = "Prahok is the heart of Cambodian flavor. It is fermented fish paste used as a seasoning in dishes like Samlor Korko, or fried/grilled in banana leaves as a main dish with fresh vegetables. A little goes a long way to add rich umami depth!";
        } else {
            $mockReply = "Khmer cuisine is characterized by a beautiful balance of flavors: sweet (from palm sugar & coconut), sour (from tamarind & lime), salty (from fish sauce & prahok), and aromatic (from Kroeung paste). How can I assist you with your cooking today?";
        }

        return $mockReply . "\n\n*(Note: Configure a GEMINI_API_KEY or OPENAI_API_KEY in your backend/.env file to activate live, unrestricted ChatGPT responses!)*";
    }
}
